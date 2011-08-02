require 'test_helper'

class FoldersControllerTest < ActionController::TestCase
  setup do
    @folder = folders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:folders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create folder" do
    assert_difference('Folder.count') do
      post :create, :folder => @folder.attributes
    end

    assert_redirected_to folder_path(assigns(:folder))
  end

  test "should show folder" do
    get :show, :id => @folder.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @folder.to_param
    assert_response :success
  end

  test "should update folder" do
    put :update, :id => @folder.to_param, :folder => @folder.attributes
    assert_redirected_to folder_path(assigns(:folder))
  end

  test "should destroy folder" do
    assert_difference('Folder.count', -1) do
      delete :destroy, :id => @folder.to_param
    end

    assert_redirected_to folders_path
  end
end
