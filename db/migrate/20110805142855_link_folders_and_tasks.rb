#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class LinkFoldersAndTasks < ActiveRecord::Migration
  def self.up
    add_column :folders, :task_id, :integer
    remove_column :folders, :project_id
  end

  def self.down
    add_column :folders, :project_id, :integer
    remove_column :folders, :task_id
  end
end
