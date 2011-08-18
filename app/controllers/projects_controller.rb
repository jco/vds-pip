class ProjectsController < ApplicationController
  # GET /projects
  def index
    @projects = Project.all
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
