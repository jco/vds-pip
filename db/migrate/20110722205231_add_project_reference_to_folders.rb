#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class AddProjectReferenceToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :project_id, :integer
  end

  def self.down
    remove_column :folders, :project_id
  end
end
