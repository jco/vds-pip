#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class ProjectsController < ApplicationController
  # GET /projects
  def index
    @projects = []
    if current_user.role == 'site_admin'  
      # only site admins the fancy jquery token field; this also gets ALL projects in index view
      @projects = Project.where("name like ?", "%#{params[:q]}%")
    else # for project managers AND normal users - see ability.rb for specific abilities.
      @projects = Project.all.select { |p| 
        (p.membership_ids & current_user.membership_ids).present?
      }
    end
    
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
      :dependencies => @project.contained_dependencies,
      :current_user_id => current_user.id
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
