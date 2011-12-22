require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test "uploading a new version should mark the document as updated, as long as nothing upstream is still not_updated" do
    document = Project.first.documents.build do |d|
      d.versions.build(:external_url => "http://google.com/")
      d.status = "not_updated"
    end
    document.save!

    assert_equal("not_updated", document.status)
    document.versions.create(:external_url => "http://yahoo.com/")
    document.reload
    assert_equal("up_to_date", document.status)
  end
end
