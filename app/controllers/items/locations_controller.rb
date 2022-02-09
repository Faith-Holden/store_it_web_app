class Items::LocationsController < ApplicationController
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
    @item.add_to_location(@location)
    redirect_to item_locations_path(@item)
  end

  def destroy
    ItemLocation.where(location_id: params[:id])
              .find_by(item_id: params[:item_id])
              .destroy
    redirect_to item_locations_path(Item.find_by(id: params[:item_id]))
  end

end
