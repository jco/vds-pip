class TasksController < ApplicationController
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
