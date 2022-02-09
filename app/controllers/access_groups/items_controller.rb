class AccessGroups::ItemsController < ApplicationController
  before_action :require_user_can_crud_item_access, only: :destroy

  def index
    @access_group = AccessGroup.find(params[:access_group_id])
    if @current_user.is_sys_admin? || @current_user.can_see_items_in_group?(@access_group)
      @locationless_items = @access_group.items.where(id: ItemLocation.locationless.pluck(:item_id))
      @items_with_location = @access_group.items.where(id: ItemLocation.with_location.pluck(:item_id))
    end
  end
  
  def new
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def create
    @item = Item.find(params[:item_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    @access_group.add_item(@item)
    redirect_to access_group_items_path(@access_group)
  end

  def destroy
    item = Item.find_by(id: params[:id])
    item_access = ItemsAccess.where(access_group_id: params[:access_group_id])&.find_by(item_id: item.id)
    item_location = ItemLocation.locationless.find_by(item_id: item.id)

    if item.locationless?
      item_access.destroy unless item_access.nil?
      flash[:success]= "Item removed from group"
    end
    
    redirect_to access_group_items_path
  end

  private
    def require_user_can_crud_item_access
      unless @current_user.can_crud_item_access?(AccessGroup.find(params[:access_group_id]))
        flash[:danger]= "You do not have permission to remove items from this group!"
        redirect_to root_url
      end
    end
end