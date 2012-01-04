#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class ProjectsController < ApplicationController
  # GET /projects
  def index
    # @projects = Project.all
    @projects = Project.where("name like ?", "%#{params[:q]}%")
    respond_to do |format| # following screencast on token fields
      format.html
      format.json { render :json => @projects.map(&:attributes) }
    end
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
    @data = {
      :project => @project,
      :dependencies => @project.contained_dependencies
    }.to_json.html_safe
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    if @project.save
      redirect_to(projects_path, :notice => 'Project was successfully created.')
    else
      render :action => "new"
    end
  end

end
