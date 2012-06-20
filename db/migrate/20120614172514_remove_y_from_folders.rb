class RemoveYFromFolders < ActiveRecord::Migration
  def self.up
    remove_column :folders, :y
  end

  def self.down
    add_column :folders, :y, :integer, :default => 0, :null => false
  end
end
