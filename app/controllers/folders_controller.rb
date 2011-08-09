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
      :dependencies => @folder.contained_dependencies
    }.to_json

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    @parent = get_folder_parent_from_params
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
    @parent = get_folder_parent_from_params
    @folder = @parent.folders.build(params[:folder])

    respond_to do |format|
      if @folder.save
        format.html { redirect_to(@parent, :notice => 'Folder was successfully created.') }
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

private

  def get_folder_parent_from_params
    if params[:folder_id]
      Folder.find(params[:folder_id])
    elsif params[:task_id]
      Task.find(params[:task_id])
    else
      raise "No parent given for folder"
    end
  end

end
