class Items::LocationsController < ApplicationController
  def index
    @item = Item.find_by(id: params[:item_id])
    if @current_user.is_sys_admin?
      @locations = @item.locations
    else
      @locations = @item.visible_locations(@current_user)
    end
  end
end
