class Locations::AccessGroupsController < ApplicationController
  before_action :require_user_can_crud, only: :destroy

  def index
    @location = Location.find(params[:location_id])
    @access_groups = @location.visible_groups(@current_user)
  end

  def new
    @location = Location.find(params[:location_id])
  end

  def create
    @location = Location.find(params[:location_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    unless @current_user.can_crud_location_access?(@access_group)
      flash[:danger]= "You do not have permission to add locations to this access group."
      redirect_to location_access_groups_path(@location)
      return
    end
    @access_group.add_location(@location)
    redirect_to location_access_groups_path(@location)
  end

  def destroy
    LocationAccess.where(access_group_id: params[:id])
              .find_by(location_id: params[:location_id])
              .destroy
    flash[:success]= "Location removed from group"
    redirect_to location_access_groups_path(Location.find_by(id: params[:location_id]))
  end

  private 
    def require_user_can_crud
      unless @current_user.can_crud_location_access?(AccessGroup.find(params[:id]))
        flash[:danger]= "You do not have permission to change which items are in this group!"
        redirect_to location_access_groups_path(Location.find_by(id: params[:location_id]))
      end
    end
end