#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Folder < ActiveRecord::Base
  include Container
  include Linkable
  self.include_root_in_json = false

  belongs_to :parent_folder, :class_name => "Folder"
  belongs_to :project
  # ONLY ONE of the above two pointers should be defined
  validate :exactly_one_parent_reference_defined

  def exactly_one_parent_reference_defined
    unless parent_folder_id.nil? ^ project_id.nil?
      errors[:base] << "Exactly one parent reference must be defined."
    end
  end

  has_many :documents
  has_many :folders, :foreign_key => 'parent_folder_id'
  has_many :downstream_dependencies, :as => :upstream_item, :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :as => :downstream_item, :class_name => "Dependency", :dependent => :destroy
  belongs_to :task
  has_many :locations, :dependent => :destroy
  
  after_update :propagate_status!, :if => :status_changed?
  after_create :create_location_objects
  
  def create_location_objects
    User.all.each { |u|
      if u.is_member_of?(self.project)
        Location.create!(:folder_id => id, :user_id => u.id, :x => session[:x].to_i, :y=>session[:y].to_i)
      end
    }

    # Adjust location
    session[:x] = "#{15+session[:x].to_i}"
    session[:y] = "#{15+session[:x].to_i}"
    # self.project.update_attribute(:x, self.project.x+15)
    # self.project.update_attribute(:y, self.project.y+15)

    # # reset to zero if at screen size
    if session[:x].to_i >= 600
      session[:x] = "0"
    end
    if session[:y] >= 400
      session[:y] = "0"
    end
    # if self.project.x >= 600
    #   self.project.update_attribute(:x, 0)
    # end
    # if self.project.y >= 400
    #   self.project.update_attribute(:y, 0)
    # end
  end
  
  # after_save callback. Sets the contents to have the same status as itself.
  def propagate_status!
    contents.each do |item|
      item.status = status
      item.save!
    end
  end

  def status
    @status ||= if contents.any? { |item| item.status == "not_updated" }
      "not_updated"
    else
      "up_to_date"
    end
  end

  def status=(val)
    status_will_change!
    @status = val
  end

  def status_will_change!
    begin
      value = status
      value = value.duplicable? ? value.clone : value
    rescue TypeError, NoMethodError
    end

    changed_attributes["status"] = value unless changed_attributes.include?("status")
  end

  def status_changed?
    changed_attributes.include?("status")
  end

  def contents
    documents + folders
  end

  def parent
    parent_folder || project
  end

  # return which project this folder is in
  alias_method :own_project_reference, :project
  def project
    own_project_reference || parent.project
  end

  def stage
    task.try(:stage)
  end

  def factor
    task.try(:factor)
  end
  
  # Gets this folder's location based on the current user's id
  def location
    locations.each do |location|
      return location if User.current.id == location.user_id
    end
    return nil
  end
  
  def coords
    return [self.location.x, self.location.y]
  end

  # This lets JS access these properties of folder - like in item_drawer.js, item.name works
  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :coords => coords,
      :folders => folders,
      :documents => documents,
      :location_id => location.id
    }
  end
    
end
