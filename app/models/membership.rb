#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Membership < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end
