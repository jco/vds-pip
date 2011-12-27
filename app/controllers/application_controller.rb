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
      Folder.find(params[:folder_id])
    elsif params[:project_id]
      Project.find(params[:project_id])
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

  # http://stackoverflow.com/questions/2385799/how-to-redirect-to-a-404-in-rails
  def render_404
    render(:text => "Not found", :status => "404")
  end

end
