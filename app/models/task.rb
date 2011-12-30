#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Task < ActiveRecord::Base
  include Container
  self.include_root_in_json = false
  belongs_to :parent_task, :class_name => "Task"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => :parent_task_id
  belongs_to :stage
  belongs_to :factor
  # stage and factor should be defined if and only if parent task is not defined
  has_many :folders
  has_many :documents

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

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :folders => folders,
      :documents => documents
    }
  end

end
