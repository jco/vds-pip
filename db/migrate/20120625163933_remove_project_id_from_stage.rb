class RemoveProjectIdFromStage < ActiveRecord::Migration
  def self.up
    remove_column :stages, :project_id
  end

  def self.down
    add_column :stages, :project_id, :integer
  end
end
