class Stage < ActiveRecord::Base
  belongs_to :project
  acts_as_list :scope => :project
  has_many :tasks
end
