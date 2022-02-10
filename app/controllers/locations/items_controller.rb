class Locations::ItemsController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    if @current_user.locations_with_visible_items.include?(@location)
      @items = @location.items
    else
      flash[:warning]= "Items in this location are not available to view."
      redirect_to location_url(@location)
    end
  end

  def new
    @location = Location.find(params[:location_id])
  end

  def create
    @location = Location.find(params[:location_id])
    @item = Item.find(params[:item_id])
    @location.add_item(@item)
    redirect_to location_items_path(@location)
  end

  def destroy
    location = Location.find_by(id: params[:location_id])
    item = Item.find(params[:id])
    item_location = ItemLocation.where(location_id: location.id).find_by(item_id: item.id)

    if ItemLocation.where(item_id: item.id).locationless.empty?
      if item_location.update_attribute(:location_id, nil)
        flash[:success]= "Item removed from location."
      end
    elsif item_location.destroy
      flash[:success]= "Item removed from location."
    else
      flash[:danger]= "Failed to remove item."
    end

    redirect_to location_items_path(Location.find_by(id: params[:location_id]))
  end
end