class Version < ActiveRecord::Base
  belongs_to :document
  validate :file_xor_url
  mount_uploader :file, DocumentUploader

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
