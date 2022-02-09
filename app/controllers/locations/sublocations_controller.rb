class Locations::SublocationsController < ApplicationController
  before_action :require_user_can_crud, only: :destroy

  def index
    @location = Location.find_by(id: params[:location_id])
    @sublocations = @location.sublocations
  end

  def new
    unless @current_user.can_crud_non_root_location?
      redirect_to root_url
      flash[:danger]= "You do not have permission to add locations!"
      return
    end
    @location = Location.find(params[:location_id])
  end

  def create
    unless @current_user.can_crud_non_root_location?
      redirect_to root_url
      return
    end

    @location = Location.find(params[:location_id])
    @sublocation = Location.new(sublocation_params)

    if @sublocation.save
      redirect_to @sublocation
    else
      render 'new'
    end
  end

  
  def destroy
    Location.find_by(id: params[:id])
            .update_attribute(:parent_id, nil)
    flash[:success]= "Sublocation removed"
    redirect_to location_sublocations_path(Location.find_by(id: params[:location_id]))
  end

  private
    def sublocation_params
      sub_params = Hash.new
      sub_params = {parent_id: params[:parent_id], description: params[:description], name: params[:name]}
      return sub_params
    end

    def require_user_can_crud
      unless @current_user.can_crud_non_root_location?
        flash[:danger]= "You do not have permission to change which items are in this group!"
        redirect_to root_url
      end
    end
end