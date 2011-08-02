class Project < ActiveRecord::Base
  self.include_root_in_json = false
  has_many :folders

  def serializable_hash(options = nil)
    {
      :documents => [],
      :folders => folders
    }
  end
end
