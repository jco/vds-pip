require 'test_helper'

class FactorsControllerTest < ActionController::TestCase
  setup do
    @factor = factors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:factors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create factor" do
    assert_difference('Factor.count') do
      post :create, :factor => @factor.attributes
    end

    assert_redirected_to factor_path(assigns(:factor))
  end

  test "should show factor" do
    get :show, :id => @factor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @factor.to_param
    assert_response :success
  end

  test "should update factor" do
    put :update, :id => @factor.to_param, :factor => @factor.attributes
    assert_redirected_to factor_path(assigns(:factor))
  end

  test "should destroy factor" do
    assert_difference('Factor.count', -1) do
      delete :destroy, :id => @factor.to_param
    end

    assert_redirected_to factors_path
  end
end
