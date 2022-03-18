class Locations::SublocationsController < ApplicationController
  before_action :require_user_can_crud, only: [:create, :new, :destroy]

  def index
    @location = Location.find_by(id: params[:location_id])
    @sublocations = @location.sublocations
  end

  def new
    @location = Location.find(params[:location_id])
  end

  def create
    @location = Location.find(params[:location_id])
    @location.sublocations << Location.find_by(id: params[:sublocation_id])
    redirect_to @location
  end

  
  def destroy
    Location.find_by(id: params[:id])
            .update_attribute(:parent_id, nil)
    flash[:success]= "Sublocation removed"
    redirect_to location_sublocations_path(Location.find_by(id: params[:location_id]))
  end

  private
    def require_user_can_crud
      unless @current_user.can_crud_non_root_location?
        flash[:danger]= "You do not have permission to change which items are in this location!"
        redirect_to location_sublocations_path(Location.find_by(id: params[:location_id]))
      end
    end
end