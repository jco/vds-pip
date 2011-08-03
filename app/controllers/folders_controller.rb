class FoldersController < ApplicationController
  # GET /folders
  # GET /folders.xml
  def index
    @folders = Folder.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @folders }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    @folder = Folder.find(params[:id])
    @project = @folder.project
    @data = {
      :project => @project,
      :this_folder => dom_id(@folder),
      :dependencies => @folder.dependencies
    }.to_json

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    if params[:folder_id]
      @parent = Folder.find(params[:folder_id])
    elsif params[:project_id]
      @parent = Project.find(params[:project_id])
    else
      raise "Can't make a folder without knowing its parent"
    end
    # duck typing
    @folder = @parent.folders.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @folder = Folder.find(params[:id])
  end

  # POST /folders
  # POST /folders.xml
  def create
    if params[:folder_id]
      @parent = Folder.find(params[:folder_id])
    elsif params[:project_id]
      @parent = Project.find(params[:project_id])
    else
      raise "Can't make a folder without knowing its parent"
    end
    @folder = @parent.folders.build(params[:folder])

    respond_to do |format|
      if @folder.save
        dest = (@parent.is_a?(Project) ? @parent : @folder)
        format.html { redirect_to(dest, :notice => 'Folder was successfully created.') }
        format.xml  { render :xml => @folder, :status => :created, :location => @folder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.xml
  def update
    @folder = Folder.find(params[:id])

    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.html { redirect_to(@folder, :notice => 'Folder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.xml
  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy

    respond_to do |format|
      format.html { redirect_to(folders_url) }
      format.xml  { head :ok }
    end
  end
end
