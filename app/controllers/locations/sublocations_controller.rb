class Locations::SublocationsController < ApplicationController
  def index
    @parent_location = Location.find(params[:location_id])
    @sublocations = @parent_location.child_locations
    # .visible_to(@current_user)
  end
end