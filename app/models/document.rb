#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Document < ActiveRecord::Base
  include Linkable
  self.include_root_in_json = false
  STATUSES = %w(up_to_date being_worked_on not_updated)
  attr_accessor :creating_FROM_dependency # a way to pass arbitrary form data for creating dependencies in _form
  attr_accessor :email
  
  # Relationships
  belongs_to :folder
  belongs_to :project
  belongs_to :task
  has_many :locations, :dependent => :destroy
  has_many :versions, :dependent => :destroy, :order => 'created_at DESC'
  has_many :downstream_dependencies, :as => :upstream_item, :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :as => :downstream_item, :class_name => "Dependency", :dependent => :destroy
  
  accepts_nested_attributes_for :versions
  # accepts_nested_attributes_for :upstream_dependencies, :allow_destroy => true#,
  #   # :reject_if => lambda { |a| a[:email].blank?} # prevent submission of blank
  
  # Validations
  validate :exactly_one_parent_reference_defined
  validate :has_at_least_one_version
  validates_inclusion_of :status, :in => STATUSES
    
  # Hooks
  after_initialize :init
  after_update :mark_downstream_items_not_updated!, :if => Proc.new { |document| document.status_changed? && document.status == "not_updated" }
  after_create :create_location_objects
  
  def exactly_one_parent_reference_defined
    unless folder_id.nil? ^ project_id.nil?
      errors[:base] << "Exactly one parent reference must be defined."
    end
  end
  
  def create_location_objects
    User.all.each { |u|
      if u.is_member_of?(self.project) || ( !self.folder.nil? && u.is_member_of?(self.folder.project) )
        Location.create!(:document_id => id, :user_id => u.id)
      end
    }
  end

  def mark_downstream_items_not_updated!
    downstream_items.each do |item|
      item.status = "not_updated"
      item.save!
    end
  end

  def init
    self.status ||= 'up_to_date'
  end

  def stage
    task.try(:stage) # task may not exist
  end

  def factor
    task.try(:factor) # task may not exist
  end

  # return folder if it exists, otherwise project
  def parent
    folder || project
  end

  def has_at_least_one_version
    if versions.empty?
      errors.add(:versions, "must have at least one version")
    end
  end
  def icon_path
    latest_version.try(:icon_path)
  end

  def latest_version
    versions.first
  end
  
  # Gets this document's location based on the current user's id
  def location
    locations.each do |location|
      return location if User.current.id == location.user_id
    end
    return nil
    # Abandoned:
    # Lazy initialization - only reached if no location for this document and user
    # final_location = Location.create!(:document_id => self.id, :user_id => User.current.id)
    # return final_location
    # Why can't this see that the location already exists? Making it once should be enough.
    # Different threads. That would explain it. But no.
  end
  
  def coords
    return [self.location.x, self.location.y]
  end
  
  # Why?
  def name
    read_attribute(:name) || latest_version.name
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :status => status,
      :coords => coords,
      :icon => icon_path,
      :location_id => location.id
    }
  end
end
