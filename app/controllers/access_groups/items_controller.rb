class AccessGroups::ItemsController < ApplicationController
  def index
    @access_group = AccessGroup.find(params[:access_group_id])
    if @current_user.is_sys_admin? || @current_user.can_see_items_in_group?(@access_group)
      @items = @access_group.items
    end
  end

  def new
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def create
    @item = Item.find(params[:item_id])
    @location = Location.find(params[:location_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    @access_group.add_item(@item, @location)
    redirect_to access_group_items_path(@access_group)
  end
end