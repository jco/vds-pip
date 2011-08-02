class Dependency < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :downstream_document, :class_name => "Document"
  belongs_to :upstream_document, :class_name => "Document"
  validates_presence_of :upstream_document
  validates_presence_of :downstream_document

  def serializable_hash(options = nil)
    [ActionController::RecordIdentifier.dom_id(upstream_document), ActionController::RecordIdentifier.dom_id(downstream_document)]
  end
end
