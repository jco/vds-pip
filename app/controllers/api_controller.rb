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

    generated_password = User.generate_password
    @user = User.new(:email => params[:new_user_email], :password => generated_password)  
    @user.memberships.build(:project_id => params[:project_id])
    if @user.save
      render(:text => "user_id=#{@user.id}&password=#{generated_password}", :status => :created)
    else
      head :unprocessable_entity
    end  
  end

  # GET /api/createtask
  def createtask
    render :text => "not finished"; return

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
    elsif params.has_key?(:stage_id) && params.has_key?(:factor_id)
      if params.has_key?(:parent_task_id)
        errors << xor_msg
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
      stage = Task.find(params[:stage_id])
      project = stage.project
    end

    # check if the user is authorized
    unless current_user.is_member_of?(project)
      render(:text => "user #{current_user} is not authorized to add a task to project #{project}", :status => :unauthorized)
      return
    end

    # they are, so try to create the task


    render :text => "this method is unfinished"
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
