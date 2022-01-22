class ItemsController < ApplicationController
  def new
    if @current_user.is_sys_admin?
      @item = Item.new
      @current_user = current_user
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
    if @current_user.items.include?(Item.find_by(id: params[:id]))
      @item = Item.find(params[:id])
    else
      flash[:danger]= "Item not available to view!"
      redirect_to root_url
    end
  end

  def index
    if current_user.is_sys_admin?
      @items = Item.all
    else
      @items = current_user.items
    end
  end

  private
  def item_params
    params.require(:item).
            permit(:name, :access_group_id, :location_id)
  end
end
