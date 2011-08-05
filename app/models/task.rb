class Task < ActiveRecord::Base
  belongs_to :parent_task, :class_name => "Task"
  has_many :sub_tasks, :class_name => "Task", :foreign_key => :parent_task_id
  belongs_to :stage
  belongs_to :factor
  has_many :folders
  has_many :documents

  def project
    if parent_task
      parent_task.project
    else
      stage.project
    end
  end
end
