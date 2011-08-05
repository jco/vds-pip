class Project < ActiveRecord::Base
  self.include_root_in_json = false
  has_many :stages
  has_many :factors

  def serializable_hash(options = nil)
    {
      :documents => [],
      :folders => [] #TODO:
    }
  end
end
