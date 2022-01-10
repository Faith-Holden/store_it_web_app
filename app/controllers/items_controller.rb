class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item
    else
      render 'new'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def index
    @items = Item.all
  end

  private
  def item_params
    params.require(:item).
            permit(:name, :access_group_id, :location_id)
  end
end
