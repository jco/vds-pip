class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.xml
  def index
    @documents = Document.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    begin
      @parent = Folder.find(params[:folder_id])
    rescue ActiveRecord::RecordNotFound 
      @parent = Task.find(params[:task_id])
    end
    @document = @parent.documents.build
    @document.versions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.xml
  def create
    begin
      @parent = Folder.find(params[:folder_id])
    rescue ActiveRecord::RecordNotFound 
      @parent = Task.find(params[:task_id])
    end
    @document = @parent.documents.build(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to(@document, :notice => 'Document was successfully created.') }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # this is sometimes called with coords, sometimes with in-place edits
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.json { render :json => nil }
        format.html { redirect_to(@document, :notice => 'Document was successfully updated.') }
        format.xml  { head :ok }
      else
        format.json { render :json => @document.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(documents_url) }
      format.xml  { head :ok }
    end
  end
end
