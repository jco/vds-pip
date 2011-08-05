class Folder < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :parent_folder, :class_name => "Folder"
  belongs_to :task
  # ONLY ONE of the above two pointers should be defined
  has_many :documents
  has_many :folders, :foreign_key => 'parent_folder_id'
  has_many :downstream_dependencies, :as => :upstream_item, :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :as => :downstream_item, :class_name => "Dependency", :dependent => :destroy

  def parent
    task || parent_folder
  end

  # return which project this folder is in
  def project
    parent.project
  end
  
  def coords
    [x, y]
  end

  # returns a list of every dependency that touches this folder
  def dependencies
    [] # TODO:
  end

  # returns all the documents that need to be ghosts in order to illustrate the deps
  def ghosts
    [] #Document.where("folder_id != ? AND 
#actually, easier for client? when referencing a doc that doesn't exist, look it up from the index and draw it
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :coords => coords,
      :folders => folders,
      :documents => documents
    }
  end

    
end
