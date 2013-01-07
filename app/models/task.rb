#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Task < ActiveRecord::Base
  include Container
  self.include_root_in_json = false
  belongs_to :parent_task, :class_name => "Task"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => :parent_task_id
  belongs_to :project
  belongs_to :factor # exactly one, always
  belongs_to :stage # exactly one, always
  
  # stage and factor should be defined if and only if parent task is not defined
  # has_many :folders
  has_one :folder
  has_many :documents
  
  validate :uniqueness
  validate :exactly_one_parent_reference_defined
  validates_presence_of :stage_id, :factor_id
  
  after_create :create_folder # do we still want this?
  
  def uniqueness
    if Task.exists?(:name => name, :stage_id => stage_id, :factor_id => factor_id) || Task.exists?(:name => name, :parent_task_id => parent_task_id)
      errors[:base] << "An identical task already exists"
    end
  end

  def parent
    parent_task || factor
  end

  alias_method :own_stage, :stage
  def stage
    own_stage || parent_task.stage
  end

  alias_method :own_factor, :factor
  def factor
    own_factor || parent_task.factor
  end

  def project
    parent.project
  end

  def soft_delete!
    touch(:deleted_at)
  end

  def deleted?
    !deleted_at.nil?
  end

  def to_s
    name
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :folders => folders,
      :documents => documents
    }
  end
  
  private
    def exactly_one_parent_reference_defined
      unless parent_task_id.nil? ^ project_id.nil?
        errors[:base] << "Exactly one parent reference must be defined."
      end
    end
    
    def create_folder
      if self.project_id
        Folder.create!(:name=>self.name, :task_id => self.id, :project_id => self.project_id)
      else
        Folder.create!(:name=>self.name, :task_id => self.id, :parent_folder_id => get_parent_folder_id_from_task)
      end
    end
  
    def get_parent_folder_id_from_task
      parent_task = self.parent_task
      return parent_task.folder.id
    end
    
end
