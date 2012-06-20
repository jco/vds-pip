#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Document < ActiveRecord::Base
  include Linkable
  self.include_root_in_json = false
  STATUSES = %w(up_to_date being_worked_on not_updated)

  belongs_to :folder
  belongs_to :project
  validate :exactly_one_parent_reference_defined
  def exactly_one_parent_reference_defined
    unless folder_id.nil? ^ project_id.nil?
      errors[:base] << "Exactly one parent reference must be defined."
    end
  end

  belongs_to :task
  has_many :locations

  has_many :versions, :dependent => :destroy, :order => 'created_at DESC'
  validate :has_at_least_one_version
  accepts_nested_attributes_for :versions
  has_many :downstream_dependencies, :as => :upstream_item, :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :as => :downstream_item, :class_name => "Dependency", :dependent => :destroy
  validates_inclusion_of :status, :in => STATUSES
  after_initialize :init
  after_update :mark_downstream_items_not_updated!, :if => Proc.new { |document| document.status_changed? && document.status == "not_updated" }
  after_create :create_location_object
  
  def create_location_object
    Location.create!(:document_id => id)
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
  
  def coords
    [location.x, location.y]
  end
  
  def name
    read_attribute(:name) || latest_version.name
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :status => status,
      :coords => coords,
      :icon => icon_path
    }
  end
end
