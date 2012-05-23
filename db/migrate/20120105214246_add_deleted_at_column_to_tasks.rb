class AddDeletedAtColumnToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :deleted_at, :datetime
  end

  def self.down
    remove_column :tasks, :deleted_at
  end
end
