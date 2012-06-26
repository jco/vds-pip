class AddTaskIdToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :task_id, :integer
  end

  def self.down
    remove_column :stages, :task_id
  end
end
