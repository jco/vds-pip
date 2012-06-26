class RemoveFactorIdFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :factor_id
  end

  def self.down
    add_column :tasks, :factor_id, :integer
  end
end
