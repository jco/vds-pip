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
end
