#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class UsersController < ApplicationController
  def new  
    @user = User.new  
  end  
    
  # POST /users/create
  # This action is designed to handle the submission of an html form for an admin.
  # For the similar api method, see ApiController#createuser
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      redirect_to root_url, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end
end
