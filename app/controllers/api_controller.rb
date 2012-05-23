#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

# See http://bit.ly/vdspipintegration for a specification for these api methods.
class ApiController < ApplicationController
  # GET /api/createuser
  # This action is designed to respond to the vds call to create a user.
  # For the corresponding html form action, see UsersController#create
  def createuser
    required_params = [:login, :password, :new_user_email, :project_id]
    unless required_params.all? { |param| params.has_key?(param) }
      render(:text => "missing parameter, must have all of #{required_params.inspect}", :status => :unprocessable_entity)
      return
    end

    return unless authenticate_with_params!

    unless Project.exists?(params[:project_id])
      render(:text => "No project exists with id=#{params[:project_id]}.", :status => :unprocessable_entity)
      return
    end

    generated_password = User.generate_password
    user = User.new(:email => params[:new_user_email], :password => generated_password)
    user.memberships.build(:project_id => params[:project_id])
    if user.save
      UserMailer.welcome_email(user, generated_password).deliver
      render(:text => "user_id=#{user.id}&password=#{generated_password}", :status => :created)
    else
      head :unprocessable_entity
    end  
  end

  # GET /api/createtask
  def createtask
    # try to catch param errors
    errors = []
    required_params = [:login, :password, :name]
    unless required_params.all? { |param| params.has_key?(param) }
      errors << "missing parameter, must have all of #{required_params.inspect}"
    end
    xor_msg = "must have either parent_task_id or a pair of (stage_id, factor_id) but not both"
    if params.has_key?(:parent_task_id)
      if params.has_key?(:stage_id) || params.has_key?(:factor_id)
        errors << xor_msg
      end
      # parent_task_id must be valid
      begin
        parent_task = Task.find(params[:parent_task_id])
      rescue ActiveRecord::RecordNotFound
        errors << "Parent task with id #{params[:parent_task_id]} does not exist."
      end
    elsif params.has_key?(:stage_id) && params.has_key?(:factor_id)
      if params.has_key?(:parent_task_id)
        errors << xor_msg
      end
      # stage_id and factor_id must be a) valid and b) from the same project
      begin
        stage = Stage.find(params[:stage_id])
      rescue ActiveRecord::RecordNotFound
        errors << "Stage with id #{params[:stage_id]} does not exist."
      end
      begin
        factor = Factor.find(params[:factor_id])
      rescue ActiveRecord::RecordNotFound
        errors << "Factor with id #{params[:factor_id]} does not exist."
      end
      unless stage.nil? or factor.nil?
        unless stage.project_id == factor.project_id
          errors << "Stage and factor belong to different projects."
        end
      end
    else
      errors << xor_msg
    end


    unless errors.empty?
      render(:text => errors.join("\n"), :status => :unprocessable_entity)
      return
    end

    # authenticate the user
    return unless authenticate_with_params!

    # find the relevant project
    if params.has_key?(:parent_task_id)
      parent_task = Task.find(params[:parent_task_id])
      project = parent_task.project
    else
      stage = Stage.find(params[:stage_id])
      project = stage.project
    end

    # check if the user is authorized
    unless current_user.is_member_of?(project)
      render(:text => "user #{current_user} is not authorized to add a task to project #{project}", :status => :unauthorized)
      return
    end

    # they are, so try to create the task
    if params.has_key?(:parent_task_id)
      task = parent_task.tasks.build(:name => params[:name])
    else
      task = Task.new(:name => params[:name], :stage => stage, :factor => factor)
    end
    if task.save
      render(:text => "task_id=#{task.id}", :status => :created)
    else
      render(:text => "There was a problem saving the task: #{task.errors}", :status => :unprocessable_entity)
    end
  end

  def deletetask
    required_params = [:login, :password, :task_id]
    unless required_params.all? { |param| params.has_key?(param) }
      render(:text => "missing parameter, must have all of #{required_params.inspect}", :status => :unprocessable_entity)
      return
    end

    return unless authenticate_with_params!

    task = Task.find(params[:task_id])
    unless task
      render(:text => "There is no task with id=#{params[:task_id]}.", :status => 404)
      return
    end

    unless !task.deleted?
      render(:text =>"The task with id=#{params[:task_id]} is already marked as deleted.", :status => 410)
      return
    end

    # delete the task
    task.soft_delete!
    head(204) # No Content
  end

  def createproject
    # TODO: require user to be site admin
    # TODO: should name be unique? can't be blank

    required_params = [:login, :password, :name]
    unless required_params.all? { |param| params.has_key?(param) }
      render(:text => "missing parameter, must have all of #{required_params.inspect}", :status => :unprocessable_entity)
      return
    end

    return unless authenticate_with_params!

    # If supplied, the user id must be valid
    if params.has_key?(:user_id)
      unless User.exists?(params[:user_id])
        render(:text => "User with id #{params[:user_id]} does not exist.", :status => :unprocessable_entity)
        return
      end
    end

    project = Project.new(:name => params[:name])
    if params.has_key?(:user_id)
      first_project_manager = User.find(params[:user_id])
    else
      first_project_manager = current_user
    end
    membership = project.memberships.build(:project => project, :user => first_project_manager)
    # would create the manager role here
    if project.save
      render(:text => "Successfully created project \"#{project.name}\" with project manager <#{first_project_manager}>", :status => :created)
    else
      render(:text => "Problem saving project(#{project.errors.inspect}) or membership(#{membership.errors.inspect}).", :status => :unprocessable_entity)
    end
  end

  def assignprojecttype
    required_params = [:login, :password, :project_id, :project_type]
    unless required_params.all? { |param| params.has_key?(param) }
      render(:text => "missing parameter, must have all of #{required_params.inspect}", :status => :unprocessable_entity)
      return
    end

    return unless authenticate_with_params!

    render(:text => "UNFINISHED")
  end

  # Important: any methods defined in this controller will automatically be
  # accessible to the outside world unless declared protected or private.

protected

  # Tries to authenticate based on the value of the params, regardless of
  # the session.
  # This method will leave the current user signed in if authentication by
  # params fails.
  def authenticate_with_params!
    authentication_succeeded = false

    if [:login, :password].all? { |p| params.has_key?(p) }
      user = User.authenticate(params[:login], params[:password])
      if user  
        sign_in(user)
        authentication_succeeded = true
      end
    end

    render(:text => "authentication failed", :status => :unauthorized) unless authentication_succeeded
    return authentication_succeeded
  end
end
