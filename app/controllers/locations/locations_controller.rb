module Locations
  class LocationsController < ApplicationController
    def create
      if @current_user.is_sys_admin?
        @location = Location.new(location_params)
        if @location.save
          redirect_to @location
        else
          render 'new'
        end
      else
        redirect_to root_url
      end
    end


    def new
      if @current_user.is_sys_admin?
        @location = Location.new
        @parent_locations = Location.all 
        # debugger
      else
        flash[:danger]= "Only the System Administrator can add locations at this time."
        redirect_to root_url
      end
    end

    def show
      if @current_user.is_sys_admin? || @current_user.locations.include?(Location.find_by(id: params[:id]))
        @location = Location.find(params[:id])
      else
        flash[:danger]= "Location not available!"
        redirect_to root_url
      end
    end

    def index
      @locations = @current_user.visible_ancestor_locations
    end

    def destroy
      @location = Location.find(params[:id])
      @location.destroy_location
    end

    private
      def location_params
        params[:parent_id] ||= nil
        params.require(:location).permit(:name, :parent_id)
      end
  end
end