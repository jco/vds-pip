class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!

protected

  # Checks to see if the client is trying to authenticate via URL params. Uses
  # the current session otherwise.
  def authenticate!
    if params.has_key?(:login)
      # The user is attempting to authenticate via params. Ignore the current user.
      user =  User.authenticate(params[:login], params[:password])
      if user
        sign_in(user)
      else
        error_screen(:development => "Authenticating via params failed", :production => :not_found) unless current_user
      end
    else
      # Try the current user.
      error_screen(:development => "No session, no authentication params", :production => :not_found) unless current_user
    end
  end

  # Renders an error screen that differs based on Rails.env.
  # Encapsulates the duality of showing specific debug info to the 
  # developer, and providing the least information possible to the user,
  # especially useful to hide information from attackers.
  #
  # Ideally, the development screen would use the builtin rails rescue
  # screen which has stack traces and other nice things.
  def error_screen(options)
    if Rails.env.production?
      raise ActionController::RoutingError.new(options[:production])
    else
      raise ActionController::RoutingError.new(options[:development])
    end
  end

  def get_parent_from_params
    if params[:folder_id]
      Folder.find(params[:folder_id])
    elsif params[:task_id]
      Task.find(params[:task_id])
    else
      raise "No parent given"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
  end
end
