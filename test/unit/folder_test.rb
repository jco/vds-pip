#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  test "status_changed? work" do
    f = Project.first.folders.create(:name => "blah")
    assert_equal("up_to_date", f.status)
    f.status = "not_updated"
    assert(f.status_changed?)

    f.status = "up_to_date"
    assert(f.status_changed?)

    f.status = "not_updated"
    f.save!
    f = Folder.find(f.id) # f.reload will not trash instance vars
    assert(f.status != "not_updated", "Reloaded folder has wrong status") # with no contents, the status should never be "out of date"
  end

  test "marking a folder out of date should change its contents and downstream items" do
    f = create_folder_with_contents
    assert_equal("up_to_date", f.status)
    f.status = "not_updated"
    f.save!
    f = Folder.find(f.id)

    assert_equal("not_updated", f.status)
    assert(f.contents.map {|item| item.status}.all? {|status| status == "not_updated"})
    assert(f.downstream_items.map {|item| item.status}.all? {|status| status == "not_updated"})
  end

  test "marking a folder up to date should mark its contents up to date" do
    f = create_folder_with_contents(["up_to_date", "being_worked_on", "not_updated"])
    f.status = "up_to_date"
    f.save!
    f = Folder.find(f.id)

    assert(f.contents.map {|item| item.status}.all? {|status| status == "up_to_date"})
  end

  test "folders with some not_updated contents should report their status as not_updated" do
    f = create_folder_with_contents(["not_updated", "up_to_date"])
    assert_equal("not_updated", f.status)
  end

  test "folders without any not_updated contents should report their status as up_to_date" do
    f = create_folder_with_contents(["up_to_date", "being_worked_on"])
    assert_equal("up_to_date", f.status)

    f = create_folder_with_contents(["being_worked_on"])
    assert_equal("up_to_date", f.status)

    f = Project.first.folders.create
    assert_equal("up_to_date", f.status)
  end

  def create_folder_with_contents(statuses = nil)
    statuses ||= ["up_to_date"] * 3
    folder = Project.first.folders.create(:name => "blah")
    statuses.each do |s|
      d = Document.new
      d.status = s
      d.versions.build(:external_url => "http://google.com/")
      d.folder = folder
      d.save!
    end
    folder.reload
    folder
  end

end
