class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  def get_parent_from_params
    if params[:folder_id]
      Folder.find(params[:folder_id])
    elsif params[:task_id]
      Task.find(params[:task_id])
    else
      raise "No parent given"
    end
  end

  def authenticate_vds
    # If the user is already signed in, do nothing (allow action to continue).
    # Otherwise, check if email/password credentials are given via params.
    # If not, fall back to the sign in view.

    return if user_signed_in?

    # try signing in
  end
end
