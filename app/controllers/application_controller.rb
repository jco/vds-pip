#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!#, :set_current_user
  around_filter :do_with_current_user

protected
  # http://stackoverflow.com/questions/7896298/safety-of-thread-current-usage-in-rails
  def do_with_current_user
    User.current = current_user # Thread.current[:user] = self.current_user
    begin
      yield
    ensure
      User.current = nil # clean up thread: Thread.current[:user] = nil
    end
  end

  # Checks to see if the client is trying to authenticate via URL params. Uses
  # the current session otherwise.
  def authenticate!
    if params.has_key?(:login)
      # The user is attempting to authenticate via params. Ignore the current user.
      user =  User.authenticate(params[:login], params[:password])
      if user
        sign_in(user)
      else
        unless current_user
          if Rails.env.production?
            # display a cryptic 404
            render_404
          else
            render(:text => "Authenticating via params failed", :status => :unauthorized)
          end
        end
      end
    else
      # Try the current user.
      unless current_user
        if Rails.env.production?
          render_404
        else
          render(:text => "No session, no authentication params", :status => :unauthorized)
        end
      end
    end
  end

  def get_parent_from_params
    if params[:folder_id]
      return Folder.find(params[:folder_id]) # also set task_id
    elsif params[:project_id]
      return Project.find(params[:project_id])
    else
      raise "No parent given"
    end
  end
  
  # def current_user_session
  #   return @current_user_session if defined?(@current_user_session)
  #   @current_user_session = UserSession.find
  # end
  # 
  # def current_user
  #   return @current_user if defined?(@current_user)
  #   @current_user = current_user_session && current_user_session.user
  # end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  # http://stackoverflow.com/questions/2385799/how-to-redirect-to-a-404-in-rails
  def render_404
    render(:text => "Not found", :status => "404")
  end

# -- Roles feature helpers --
# This makes the following methods accessible in the view
helper_method :current_user, :logged_in?, :logged_in_as_normal_user?, :logged_in_as_project_manager?, :logged_in_as_site_admin?

# CanCan code
rescue_from CanCan::AccessDenied do |exception|
  flash[:notice] = "You do not have access to this page."
  redirect_to root_url, :alert => exception.message
end

private
  def logged_in?
    current_user
  end
  
  def logged_in_as_normal_user?
	  current_user && current_user.role == 'normal_user'
  end
  
	def logged_in_as_project_manager?
	  current_user && current_user.role == 'project_manager'
  end

  def logged_in_as_site_admin?
    current_user && current_user.role == 'site_admin'
  end
  
  def require_normal_user
    unless logged_in_as_normal_user?
      flash[:notice] = "You must be logged in as a normal user to access this page."
      redirect_to '/'
      return false
    end
  end
  
  def require_project_manager
    unless logged_in_as_project_manager?
      flash[:notice] = "You must be logged in as a project manager to access this page."
      redirect_to '/'
      return false
    end
  end
  
  def require_site_admin
    unless logged_in_as_site_admin?
      flash[:notice] = "You must be logged in as a site admin to access this page."
      redirect_to '/'
      return false
    end
  end
  
  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page."
      redirect_to '/'
      return false
    end
  end
end
