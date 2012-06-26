class RemoveProjectIdFromFactor < ActiveRecord::Migration
  def self.up
    remove_column :factors, :project_id
  end

  def self.down
    add_column :factors, :project_id, :integer
  end
end
