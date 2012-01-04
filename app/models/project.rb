#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Project < ActiveRecord::Base
  include Container
  self.include_root_in_json = false
  has_many :stages, :order => :position
  has_many :factors
  has_many :memberships

  # These are only the top-level docs and folders.
  has_many :documents
  has_many :folders

  def tasks
    stages.map { |stage| stage.tasks }.flatten
  end
    

  def serializable_hash(options = nil)
    {
      :id => id,
      :name => name,
      :folders => folders,
      :documents => documents
    }
  end

  def to_s
    self.name
  end
end
