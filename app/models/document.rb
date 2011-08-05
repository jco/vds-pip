class Document < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :folder
  belongs_to :task
  # should have only one of the above defined at any one time
  has_many :versions, :dependent => :destroy, :order => 'created_at DESC'
  validate :has_at_least_one_version
  accepts_nested_attributes_for :versions
  has_many :downstream_dependencies, :foreign_key => 'upstream_document_id', :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :foreign_key => 'downstream_document_id', :class_name => "Dependency", :dependent => :destroy

  def has_at_least_one_version
    if versions.empty?
      errors.add(:versions, "must have at least one version")
    end
  end
  def icon_path
    latest_version.try(:icon_path)
  end

  def latest_version
    versions.first
  end
  
  def coords
    [x, y]
  end
  
  def name
    read_attribute(:name) || latest_version.name
  end

  def serializable_hash(options = nil)
    {
      :name => name,
      :id => id,
      :status => 1,
      :coords => coords,
      :icon => icon_path
    }
  end
end
