class AccessGroups::LocationsController < ApplicationController
  def index
    @access_group = AccessGroup.find(params[:access_group_id])
    if @current_user.is_sys_admin? || @current_user.can_see_locations_in_group?(@access_group)
      @locations = @access_group.locations
    end
  end

  def new
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def create
    @location = Location.find(params[:location_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    @access_group.add_location(@location)
    redirect_to access_group_locations_path(@access_group)
  end


end