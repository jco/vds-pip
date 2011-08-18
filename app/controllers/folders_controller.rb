class FoldersController < ApplicationController
  # GET /folders/1
  def show
    @folder = Folder.find(params[:id])
    @project = @folder.project
    @data = {
      :project => @project,
      :this_folder => dom_id(@folder),
      :dependencies => @folder.contained_dependencies
    }.to_json
  end

  # GET /tasks/1/folders/new OR /folders/1/folders/new
  def new
    @parent = get_parent_from_params
    @folder = @parent.folders.build
  end

  # POST /tasks/1/folders OR /folders/1/folders
  def create
    @parent = get_parent_from_params
    @folder = @parent.folders.build(params[:folder])

    if @folder.save
      redirect_to(@parent, :notice => 'Folder was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /folders/1
  def update
    folder = Folder.find(params[:id])

    if folder.update_attributes(params[:folder])
      render(:json => nil, :status => :ok)
    else
      render(:json => folder.errors, :status => :unprocessable_entity)
    end
  end

end
