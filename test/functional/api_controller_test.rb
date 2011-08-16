require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "task creation" do
    Users.create(:email => 'sample@sample.com', :password => 'test')
    get(:createtask, {:login => '', :password => '', :name => '', :parent_task_id => ''})
  end
end
