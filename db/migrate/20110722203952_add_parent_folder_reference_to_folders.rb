class AddParentFolderReferenceToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :parent_folder_id, :integer
  end

  def self.down
    remove_column :folders, :parent_folder_id
  end
end
