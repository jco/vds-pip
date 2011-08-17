class TasksController < ApplicationController
  # GET /projects/1/tasks
  # for showing more than one task
  def index
    # user is authorized?
    project = Project.find(params[:project_id])
    unless current_user.is_member_of?(project)
      error_screen(:development => "User #{current_user} doesn't have permissions to view project #{project}", :production => :not_found)
    end

    @tasks = project.tasks
  end

  # GET /tasks/1
  def show
    @task = Task.find(params[:id])
    project = @task.project
    @data = {
      :project => project,
      :this_task => dom_id(@task),
      :dependencies => @task.contained_dependencies
    }.to_json.html_safe
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(params[:task])

    if @task.save
      redirect_to(@task, :notice => 'Task was successfully created.')
    else
      render :action => "new"
    end
  end

end
