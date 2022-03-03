class Items::LocationsController < ApplicationController
  
  before_action :require_user_can_crud, only: [:create, :new, :destroy]
  
  def index
    @item = Item.find_by(id: params[:item_id])
    if @current_user.is_sys_admin?
      @locations = @item.locations
    else
      @locations = @item.visible_locations(@current_user)
    end
  end

  
  def new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find(params[:item_id])
    @location = Location.find(params[:location_id])
    @location.add_item(@item)
    redirect_to item_locations_path(@item)
  end

  def destroy
    ItemLocation.where(location_id: params[:id])
              .find_by(item_id: params[:item_id])
              .destroy
    redirect_to item_locations_path(Item.find_by(id: params[:item_id]))
  end

  private
  def require_user_can_crud
    # This will need to be updated to have a better requirement.
    unless current_user.is_sys_admin?
      flash[:danger]= "You do not have permission to add or remove items from this location!"
      redirect_to item_path(Item.find_by(params[:item_id]))
    end
  end

end
