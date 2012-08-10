#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class DependenciesController < ApplicationController
  # GET /folders/1/dependencies
  def index
    folder = Folder.find(params[:folder_id])
    dependencies = folder.dependencies
    render :json => dependencies
  end

  # POST /dependencies
  def create
    @dependency = Dependency.new(params[:dependency])
    @dependency.save
    head :created
  end
  
  # This is called from a remote link in documents/show, only
  def destroy
    @dependency = Dependency.find(params[:id])
    @dependency.destroy
    # :remote => true is set for the destroy link, so no redirect is necessary
    # why 500 internal server error?
  end
end
