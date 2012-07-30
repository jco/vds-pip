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
    puts '-----------------------------------------'
    puts "document update called: params[:document]: #{params[:document]}"
    puts '-----------------------------------------'
    respond_to do |format|
      if @document.update_attributes(params[:document])
        puts '-----------------------------------------'
        puts "good"
        puts '-----------------------------------------'
        format.json { render :json => nil, :status => :ok }
        format.html { redirect_to(@document, :notice => 'Document was successfully updated.') }
      else
        puts '-----------------------------------------'
        puts "bad"
        puts '-----------------------------------------'
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
