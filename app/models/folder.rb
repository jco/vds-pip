class Folder < ActiveRecord::Base
  include Container
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

  def stage
    parent.stage
  end

  def factor
    parent.factor
  end
  
  def coords
    [x, y]
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
