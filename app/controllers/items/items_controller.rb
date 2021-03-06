module Items
  class ItemsController < ApplicationController
    before_action :require_user_can_crud_items, except: :index

    def new
      @item = Item.new
      @parent_locations = Location.all 
    end

    def create
      @item = Item.new(item_params)
      if @item.save
        redirect_to @item
      else
        redirect_to new_item_path
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

    def edit
      @item = Item.find_by(id: params[:id])
    end

    def update
      @item = Item.find_by(id: params[:id])
      if @item.update(item_params)
        flash[:success]= "Item updated"
        redirect_to @item
      else
        redirect_to edit_item_path(@item)
      end
    end

  private
    def item_params
      params.require(:item)
            .permit(:name, :location_id, :description, :image)
    end

    def require_user_can_crud_items
      unless current_user.can_crud_items?
        flash[:danger]= "You do not have permission to delete items!"
        redirect_to items_path
      end
    end
  end
end