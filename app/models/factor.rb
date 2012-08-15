#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Factor < ActiveRecord::Base
  self.include_root_in_json = false
  # belongs_to :project
  
  has_many :tasks

  validates_presence_of :name
  
  def to_s
    name
  end
end
