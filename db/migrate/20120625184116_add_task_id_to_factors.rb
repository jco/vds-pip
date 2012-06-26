class AddTaskIdToFactors < ActiveRecord::Migration
  def self.up
    add_column :factors, :task_id, :integer
  end

  def self.down
    remove_column :factors, :task_id
  end
end
