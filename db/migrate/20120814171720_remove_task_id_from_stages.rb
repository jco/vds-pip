class RemoveTaskIdFromStages < ActiveRecord::Migration
  def self.up
    remove_column :stages, :task_id
  end

  def self.down
    add_column :stages, :task_id, :integer
  end
end
