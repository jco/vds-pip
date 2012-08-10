#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class Dependency < ActiveRecord::Base
  self.include_root_in_json = false
  attr_accessible :upstream_item_id, :upstream_item_type, :downstream_item_id, :downstream_item_type
  
  belongs_to :upstream_item, :polymorphic => true
  belongs_to :downstream_item, :polymorphic => true
  # validate later: upstream_item_type and downstream_item_type are either "Folder" or "Document"

  validates_presence_of :upstream_item
  validates_presence_of :downstream_item

  def serializable_hash(options = nil)
    [ActionController::RecordIdentifier.dom_id(upstream_item), ActionController::RecordIdentifier.dom_id(downstream_item)]
  end
  
end
