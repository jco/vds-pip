class AddProjectReferenceToDocumentsAndFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :project_id, :integer
    add_column :documents, :project_id, :integer
    Folder.all.each do |f|
      f.project_id = 1
      f.save
    end
    Document.all.each do |d|
      d.project_id = 1
      d.save
    end
  end

  def self.down
    remove_column :folders, :project_id
    remove_column :documents, :project_id
  end
end
