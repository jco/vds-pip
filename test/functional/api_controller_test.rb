#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

# TESTS HERE PROBABLY DON'T WORK ANYMORE AFTER DRASTIC DATABASE REMODELING (the commit after "cleaned up locations for document...")

require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "create user" do
    # all valid params
    get(:createuser, credentials.merge(:new_user_email => 'test@gmail.com', :project_id => Project.first.id))
    assert_response(201)
    assert(@response.body.include?("user_id="))

    # can't save a user, e.g. because of an invalid email address
    get(:createuser, credentials.merge(:new_user_email => 'notanemail', :project_id => Project.first.id))
    assert_response(422)

    # invalid project_id
    invalid_project_id = "this is not an integer"
    assert(!Project.exists?(invalid_project_id))
    get(:createuser, credentials.merge(:new_user_email => 'test2@gmail.com', :project_id => invalid_project_id))
    assert_response(422)
  end

  test "task creation failure" do
    # valid credentials but missing params should result in an error
    get(:createtask, credentials)
    assert_response(:unprocessable_entity)
  end

  test "duplicate task" do
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    task_attributes = {:name => "duplicate task", :stage_id => stage.id, :factor_id => factor.id}
    task = Task.new(task_attributes)
    assert(task.save)
    get(:createtask, credentials().merge(task_attributes))
    assert_response(422)
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

  test "task creation restore" do
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    task_attributes = {:name => "Some other name", :stage_id => stage.id, :factor_id => factor.id}
    task = Task.new(task_attributes)
    assert(task.save)
    task.soft_delete!
    assert(task.deleted?)
    get(:createtask, credentials.merge(task_attributes))
    assert_response(200)
    task.reload
    assert(!task.deleted?)
  end

  test "delete task, normal case" do
    task = Task.new(generate_task_attributes())
    assert(task.save)
    assert(!task.deleted?)
    get(:deletetask, credentials().merge(:task_id => task.id))
    assert_response(204)
    task.reload
    assert(task.deleted?)
  end

  test "project creation success" do
    assert(!Project.exists?(:name => "Some project name"))
    get(:createproject, credentials.merge(:name => "Some project name"))
    assert_response(201, @response.body)
    assert(Project.exists?(:name => "Some project name"))
  end

  def credentials
    {:login => "admin@example.com", :password => "admin"}
  end

  def generate_task_attributes(name = "Some name")
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    {:name => name, :stage_id => stage.id, :factor_id => factor.id}
  end
end

