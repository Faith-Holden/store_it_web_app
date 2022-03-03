class Locations::ItemsController < ApplicationController

  before_action :require_user_can_crud, only: [:destroy, :new, :create]
  before_action :require_user_can_see_items_in_location, only: :index


  def index
    @items = @location.items
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

  private
    def require_user_can_see_items_in_location
      @location = Location.find(params[:location_id])
      if current_user.is_sys_admin?
        return
      end

      unless current_user.locations_with_visible_items.include?(@location)
        flash[:warning]= "Items in this location are not available to view."
        redirect_to location_url(@location)
      end
    end

    def require_user_can_crud
      # This will need to be updated to have a better requirement.
      unless current_user.is_sys_admin?
        flash[:danger]= "You do not have permission to add or remove items from this location!"
        redirect_to location_items_path(Location.find_by(params[:location_id]))
      end
    end
end