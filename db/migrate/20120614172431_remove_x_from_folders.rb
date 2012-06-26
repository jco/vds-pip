class RemoveXFromFolders < ActiveRecord::Migration
  def self.up
    remove_column :folders, :x
  end

  def self.down
    add_column :folders, :x, :integer, :default => 0, :null => false
  end
end
