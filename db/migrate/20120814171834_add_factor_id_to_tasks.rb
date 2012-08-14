class AddFactorIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :factor_id, :integer
  end

  def self.down
    remove_column :tasks, :factor_id
  end
end
