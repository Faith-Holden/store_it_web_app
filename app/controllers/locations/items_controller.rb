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
end