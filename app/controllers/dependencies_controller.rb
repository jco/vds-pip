#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class DependenciesController < ApplicationController
  # GET /folders/1/dependencies
  def index
    folder = Folder.find(params[:folder_id])
    dependencies = folder.dependencies
    render :json => dependencies
  end

  # GET /documents/1/dependencies/new
  def new
    @document = Document.find(params[:document_id])
    @project = @document.project
  end

  # POST /dependencies
  def create
    # need to distinguish between ajax requests made via dragging arrows
    # vs requests from /documents/1/dependencies/new
    if params.has_key?(:document_id)
      # request was from the web form
      document = Document.find(params[:document_id])
      # inverse of dom_id
      klass, id = params[:upstream_item].split(/_(?!.*_)/) # http://www.christopherirish.com/2010/10/15/splitting-rails-dom-ids-with-regex-look-aheads/
      upstream_item = klass.camelize.constantize.find(id)
      # render(:text => [upstream_item, document, klass, id].inspect)
      dependency = Dependency.new(:downstream_item => document, :upstream_item => upstream_item)
      if dependency.save
        flash[:new_dependency] = params[:upstream_item]
        redirect_to(document)
      else
        render(:text => "oh noes")
      end
    else
      # request was from ajax
      @dependency = Dependency.new(params[:dependency])
      @dependency.save
      head :created
    end
  end

  # DELETE /dependencies/1
  def destroy
    @dependency = Dependency.find(params[:id])
    @dependency.destroy
    redirect_to(:back)
  end
end
