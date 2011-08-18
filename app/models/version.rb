class Version < ActiveRecord::Base
  belongs_to :document
  validate :file_xor_url
  after_create :mark_document_up_to_date!, :unless => Proc.new { |version|
    version.document.upstream_items.any? { |item| item.status == "not_updated" }
  }
  after_create { |version| version.document.mark_downstream_items_not_updated! }
  mount_uploader :file, DocumentUploader

  def mark_document_up_to_date!
    document.status = "up_to_date"
    document.save!
  end

  # must have a file or a url but not both
  def file_xor_url
    unless external_url.blank? ^ file.blank?
      errors[:base] << "Choose a file or a link but not both."
    end
  end

  def icon_path
    # return something like '/images/icons/folder.png'
    # TODO
    '/images/icons/unknown.gif'
  end

  def name
    # for files, use the filename. for urls, use the url?
    if file.blank?
      external_url
    else
      self[:file]
    end
  end
end
