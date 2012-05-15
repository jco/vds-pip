#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class UsersController < ApplicationController
  load_and_authorize_resource # checks actions (more specifically) based on ability.rb
	
  def new  
    @user = User.new
  end
    
  # POST /users/create
  # This action is designed to handle the submission of an html form for an admin.
  # For the similar api method, see ApiController#createuser
  def create  
    @user = User.new(params[:user])
    
    # for normal user making another user, only
    if logged_in_as_normal_user?
      # http://stackoverflow.com/questions/5054633/rails-3-has-many-through-form-with-checkboxes
      @user.attributes = {'project_ids' => []}.merge(params[:user] || {})
    end
    
    if @user.save  
      redirect_to root_url, :notice => "Signed up!"  
    else  
      render "new"  
    end  
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    # http://stackoverflow.com/questions/5054633/rails-3-has-many-through-form-with-checkboxes
    # @user.attributes = {'project_ids' => []}.merge(params[:user] || {})
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated."
      redirect_to users_path
    else
      render :action => :edit
    end
  end
  
  def index
    @site_admins = User.where(:role => 'site_admin')
    @project_managers = User.where(:role => 'project_manager')
    @normal_users = User.where(:role => 'normal_user')
  end
  
  # change later so no real deletion (?)
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to '/', :notice => "Account deleted."
  end
end
