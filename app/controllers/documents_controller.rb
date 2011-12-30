#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class DocumentsController < ApplicationController
  # GET /documents/1
  def show
    @document = Document.find(params[:id])
  end

  # GET /folders/1/documents/new OR /tasks/1/documents/new
  def new
    @parent = get_parent_from_params
    @document = @parent.documents.build
    @document.versions.build
  end

  # POST /folders/1/documents OR /tasks/1/documents
  def create
    @parent = get_parent_from_params
    @document = @parent.documents.build(params[:document])

    if @document.save
      redirect_to(@document, :notice => 'Document was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /documents/1
  # this is sometimes called with coords, sometimes with in-place edits
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.json { render :json => nil }
        format.html { redirect_to(@document, :notice => 'Document was successfully updated.') }
      else
        format.json { render :json => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    head :ok
  end

end
