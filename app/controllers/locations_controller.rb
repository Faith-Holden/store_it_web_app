class LocationsController < ApplicationController
  def create
    if @current_user.is_sys_admin?
      @location = Location.new(location_params)
      if @location.save
        redirect_to @location
      else
        render 'new'
      end
    else
      redirect_to root_url
    end
  end

  def new
    if @current_user.is_sys_admin?
      @location = Location.new
      @current_user = current_user
      @parent_locations = Location.all 
    else
      flash[:danger]= "Only the System Administrator can add locations at this time."
      redirect_to root_url
    end
  end

  def show
    if @current_user.is_sys_admin? || @current_user.locations.include?(Location.find_by(id: params[:id]))
      @location = Location.find(params[:id])
    else
      flash[:danger]= "Location not available!"
      redirect_to root_url
    end
  end

  def index
    if current_user.is_sys_admin?
      @locations = Location.all
    else
      @locations = @current_user.locations
    end
  end

  def items
    @location = Location.find(params[:id])
    if @current_user.locations_with_visible_items.include?(@location)
      @items = @location.items
    else
      flash[:warning]= "Items in this location are not available to view."
      redirect_to location_url(@location)
    end
  end

  def child_locations
    @parent_location = Location.find(params[:id])
    @child_locations = @parent_location.child_locations.visible_to(@current_user)
  end

  def access_groups
    @location = Location.find(params[:id])
    @access_groups = @location.visible_groups(@current_user)
  end


  private
    def location_params
      params.require(:location).permit(:name, :parent_id)
    end
end
