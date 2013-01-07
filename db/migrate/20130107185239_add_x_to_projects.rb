class AddXToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :x, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :x
  end
end
