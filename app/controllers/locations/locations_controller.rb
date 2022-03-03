module Locations
  class LocationsController < ApplicationController
    before_action :require_can_crud_locations_with_parent, only: [:destroy, :create, :new, :update, :edit]
    def create
      @location = Location.new(location_params)
      if @location.save
        redirect_to @location
      else
        redirect_to new_location_path
      end
    end


    def new
      if @current_user.is_sys_admin?
        @location = Location.new
        @parent_locations = @current_user.locations
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
        redirect_to locations_path
      end
    end

    def index
      @locations = @current_user.visible_ancestor_locations
    end

    def destroy
      @location = Location.find(params[:id])
      @location.destroy_location
      redirect_to locations_path
    end

    def edit
      @location = Location.find_by(id: params[:id])
      @parent_locations = @current_user.locations
    end

    def update
      @location = Location.find_by(id: params[:id])
      if @location.update(location_params)
        flash[:success]= "Location updated"
        redirect_to @location
      else
        redirect_to edit_location_path(@location)
      end
    end

    private
      def location_params
        params[:parent_id] ||= nil
        params.require(:location).permit(:name, :parent_id, :description)
      end

      def require_can_crud_locations_with_parent
        unless current_user.can_crud_non_root_location?
          flash[:danger] = "You do not have permission to create, edit, or destroy these locations."
          redirect_to locations_path
        end
      end
  end
end