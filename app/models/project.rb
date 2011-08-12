class Project < ActiveRecord::Base
  self.include_root_in_json = false
  has_many :stages, :order => :position
  has_many :factors
  has_many :memberships, :dependent => :destroy

  def serializable_hash(options = nil)
    {
      :id => id,
      :name => name,
      :stages => stages
    }
  end
end
