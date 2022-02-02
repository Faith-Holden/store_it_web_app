class Items::AccessGroupsController < ApplicationController
  def index
    @item = Item.find_by(id: params[:item_id])
    @access_groups = @item.access_groups
  end

  
  def new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find(params[:item_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    @item.add_to_group(@access_group)
    redirect_to item_access_groups_path(@item)
  end

end
