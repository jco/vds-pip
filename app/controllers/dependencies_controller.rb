class DependenciesController < ApplicationController
  # GET /folders/1/dependencies
  def index
    folder = Folder.find(params[:folder_id])
    dependencies = folder.dependencies
    render :json => dependencies
  end
end
