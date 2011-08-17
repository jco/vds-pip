class Document < ActiveRecord::Base
  self.include_root_in_json = false
  STATUSES = %w(up_to_date being_worked_on not_updated)

  belongs_to :folder
  belongs_to :task
  # should have only one of the above defined at any one time
  has_many :versions, :dependent => :destroy, :order => 'created_at DESC'
  validate :has_at_least_one_version
  accepts_nested_attributes_for :versions
  has_many :downstream_dependencies, :as => :upstream_item, :class_name => "Dependency", :dependent => :destroy
  has_many :upstream_dependencies, :as => :downstream_item, :class_name => "Dependency", :dependent => :destroy
  validates_inclusion_of :status, :in => STATUSES
  after_initialize :init

  def init
    self.status ||= 'up_to_date'
  end

  def stage
    parent.stage
  end

  def factor
    parent.factor
  end

  # return folder if it exists, otherwise task
  def parent
    folder || task
  end

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
      :status => status,
      :coords => coords,
      :icon => icon_path
    }
  end
end
