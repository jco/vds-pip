#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require 'test_helper'

# TESTS HERE PROBABLY DON'T WORK ANYMORE AFTER DRASTIC DATABASE REMODELING (the commit after "cleaned up locations for document...")

class TaskTest < ActiveSupport::TestCase
  test "normal task creation" do
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    task = Task.new(:name => "A name", :stage_id => stage.id, :factor_id => factor.id)
    assert(task.save)
  end

  test "duplicate task creation" do
    project = Project.first
    stage = project.stages.first
    factor = project.factors.first
    task_attributes = {:name => "A name", :stage_id => stage.id, :factor_id => factor.id}
    task = Task.new(task_attributes)
    assert(task.save)
    task2 = Task.new(task_attributes)
    assert(!task2.save)

    task_attributes2 = {:name => "A name", :parent_task => task}
    task3 = Task.new(task_attributes2)
    assert(task3.save)
    task4 = Task.new(task_attributes2)
    assert(!task4.save)
  end
end
