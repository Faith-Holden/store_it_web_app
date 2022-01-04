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
    if Item.any?
      @item = Item.find(params[:id])
    else
      redirect_to new_item_path
    end
  end

  private
  def item_params
    params.require(:item).
            permit(:item_name)
  end
end
