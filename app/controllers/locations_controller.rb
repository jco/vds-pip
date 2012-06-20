#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

class LocationsController < ApplicationController
  # PUT /locations/1
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:folder])
      render(:json => nil, :status => :ok)
    else
      render(:json => @location.errors, :status => :unprocessable_entity)
    end
  end
end
