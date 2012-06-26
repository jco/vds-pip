class RemoveStageIdFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :stage_id
  end

  def self.down
    add_column :tasks, :stage_id, :integer
  end
end
