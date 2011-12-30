#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class AddCoordsToItems < ActiveRecord::Migration
  def self.up
    add_column :folders, :x, :integer, :default => 0, :null => false
    add_column :folders, :y, :integer, :default => 0, :null => false
    add_column :documents, :x, :integer, :default => 0, :null => false
    add_column :documents, :y, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :folders, :x
    remove_column :folders, :y
    remove_column :documents, :x
    remove_column :documents, :y
  end
end
