#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "task creation failure" do
    # valid credentials but missing params should result in an error
    get(:createtask, credentials)
    assert_response(:unprocessable_entity)
  end

  test "task creation success" do
    assert(!Task.exists?(:name => "Some task name"))
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    get(:createtask, credentials.merge(:name => "Some task name", :stage_id => stage.id, :factor_id => factor.id))
    assert_response(201)
    assert(Task.exists?(:name => "Some task name"))
  end

  test "project creation success" do
    assert(!Project.exists?(:name => "Some project name"))
    get(:createproject, credentials.merge(:name => "Some project name"))
    assert_response(201)
    assert(Project.exists?(:name => "Some project name"))
  end

  test "assigning project type" do
    # this test is going to fail until projects have the notion of a type
    flunk "Projects don't even have types yet"
  end

  def credentials
    {:login => "admin@example.com", :password => "admin"}
  end
end

