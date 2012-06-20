# require 'composite_primary_keys'
class Location < ActiveRecord::Base
  # set_primary_keys :user_id, :folder_id, :document_id
  belongs_to :user
  belongs_to :folder
  belongs_to :document
  
  validate :folder_xor_document
  
  # must have a folder id or a document id but not both
  def folder_xor_document
    unless folder_id.blank? ^ document_id.blank?
      errors[:base] << "Location can only be for a folder or a document - not both."
    end
  end
end
