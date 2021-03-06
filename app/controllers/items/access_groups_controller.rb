class Items::AccessGroupsController < ApplicationController
  before_action :require_user_can_crud, only: :destroy
  
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
    unless @current_user.can_crud_item_access?(@access_group)
      flash[:danger]= "You do not have permission to add items to this group!"
      redirect_to item_path(@item)
      return
    end
    @access_group.add_item(@item)
    redirect_to item_access_groups_path(@item)
  end

  def destroy
    ItemsAccess.where(access_group_id: params[:id])
              .find_by(item_id: params[:item_id])
              .destroy
    redirect_to item_access_groups_path(Item.find_by(id: params[:item_id]))
  end

  private 
    def require_user_can_crud
      unless current_user.can_crud_item_access?(AccessGroup.find(params[:id]))
        flash[:danger]= "You do not have permission to change which items are in this group!"
        redirect_to item_path(Item.find_by(params[:item_id]))
      end
    end
end
