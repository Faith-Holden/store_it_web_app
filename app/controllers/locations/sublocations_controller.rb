class Locations::SublocationsController < ApplicationController
  def index
    @location = Location.find_by(id: params[:location_id])
    @sublocations = @location.child_locations
  end

  def new
    unless @current_user.can_crud_non_root_location?
      redirect_to root_url
      flash[:danger]= "You do not have permission to add locations!"
      return
    end
    @location = Location.find(params[:location_id])
  end

  def create
    unless @current_user.can_crud_non_root_location?
      redirect_to root_url
      return
    end

    @location = Location.find(params[:location_id])
    @sublocation = Location.new(sublocation_params)

    if @sublocation.save
      redirect_to @sublocation
    else
      render 'new'
    end
  end

  private
    def sublocation_params
      sub_params = Hash.new
      sub_params = {parent_id: params[:parent_id], description: params[:description], name: params[:name]}
      return sub_params
    end
end