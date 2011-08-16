class Project < ActiveRecord::Base
  self.include_root_in_json = false
  has_many :stages, :order => :position
  has_many :factors

  def tasks
    stages.map { |stage| stage.tasks }.flatten
  end
    

  def serializable_hash(options = nil)
    {
      :id => id,
      :name => name,
      :stages => stages
    }
  end

  def to_s
    self.name
  end
end
