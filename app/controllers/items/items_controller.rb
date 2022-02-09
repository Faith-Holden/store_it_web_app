module Items
  class ItemsController < ApplicationController
    before_action :require_user_can_crud_items, only: :destroy

    def new
      if current_user.is_sys_admin?
        @item = Item.new
        @current_user = current_user #verify that this can be removed
        @parent_locations = Location.all 
      else
        flash[:danger]= "Only the System Administrator can add items at this time."
        redirect_to root_url
      end
    end

    def create
      if @current_user.is_sys_admin?
        @item = Item.new(item_params)
        if @item.save
          redirect_to @item
        else
          render 'new'
        end
      else
        redirect_to root_url
      end
    end

    def show
      if @current_user.is_sys_admin? || @current_user.items.include?(Item.find_by(id: params[:id]))
        @item = Item.find(params[:id])
      else
        flash[:danger]= "Item not available to view!"
        redirect_to root_url
      end
    end

    def index
      if @current_user.is_sys_admin?
        @items = Item.all
      else
        @items = @current_user.items
      end
    end

    def destroy
      if Item.find_by(id: params[:id]).destroy
        flash[:success] = "Item successfully deleted"
      else
        flash[:danger]= "Failed to delete item"
      end
      redirect_to items_url
    end

  private
    def item_params
      params.require(:item)
            .permit(:name, :location_id)
    end

    def require_user_can_crud_items
      unless @current_user.can_crud_items?
        flash[:danger]= "You do not have permission to delete items!"
        redirect_to root_url
      end
    end
  end
end