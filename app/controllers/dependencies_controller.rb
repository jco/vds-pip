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
end
