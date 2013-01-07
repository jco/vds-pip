class AddYToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :y, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :y
  end
end
