class AddStageIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :stage_id, :integer
  end

  def self.down
    remove_column :tasks, :stage_id
  end
end
