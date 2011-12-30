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

  after_update :propagate_status!, :if => :status_changed?

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
  
  def coords
    [x, y]
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :coords => coords,
      :folders => folders,
      :documents => documents
    }
  end

    
end
