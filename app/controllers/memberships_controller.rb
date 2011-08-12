class MembershipsController < ApplicationController
  # GET /project/1/memberships
  def index
    @project = Project.find(params[:project_id])
    @memberships = @project.memberships
  end

  # POST /memberships
  def create
    @membership = Membership.new(params[:membership])
    if @membership.save
      render :json => nil, :status => :created
    else
      render :json => @membership.errors, :status => :unprocessable_entity
    end
  end

  # PUT /memberships/1
  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      render :json => nil, :status => :created
    else
      render :json => @membership.errors, :status => :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    render :json => nil, :status => :ok
  end

end
