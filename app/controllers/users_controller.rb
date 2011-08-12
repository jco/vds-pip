class UsersController < ApplicationController
  def create
    render :text => "This is a stub for user creation. The params you supplied were #{params.inspect}"
  end
end
