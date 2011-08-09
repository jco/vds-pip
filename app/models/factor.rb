class Factor < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :project
  has_many :tasks
end
