class VersionsController < ApplicationController
  # GET /versions/1
  def show
    @version = Version.find(params[:id])
    unless @version.external_url.blank?
      redirect_to @version.external_url
    else
      send_file @version.file.file.file
    end
  end

  # GET /documents/1/versions/new
  def new
    @document = Document.find(params[:document_id])
    @version = @document.versions.build
  end

  # POST /documents/1/versions
  def create
    @document = Document.find(params[:document_id])
    @version = @document.versions.build(params[:version])

    if @version.save
      redirect_to(@document, :notice => 'Version was successfully created.')
    else
      render :action => "new"
    end
  end
end
