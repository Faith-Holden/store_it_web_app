class Locations::AccessGroupsController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    @access_groups = @location.visible_groups(@current_user)
  end
end