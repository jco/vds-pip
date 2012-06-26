#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Factor < ActiveRecord::Base
  self.include_root_in_json = false
  # belongs_to :project
  # has_many :tasks
  belongs_to :task

  def to_s
    name
  end
end
