class RemoveTaskIdFromFactors < ActiveRecord::Migration
  def self.up
    remove_column :factors, :task_id
  end

  def self.down
    add_column :factors, :task_id, :integer
  end
end
