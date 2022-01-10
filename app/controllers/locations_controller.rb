class LocationsController < ApplicationController
  def create
    # should add location parent
    # should make access group be access group it was created from
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location
    else
      render 'new'
    end
  end

  def new
    # should redirect if not logged in/not with access group perms
    @location = Location.new
  end

  def show
    # show specified page or reroute to sign in if not signed in
    @location = Location.find(params[:id])
  end

  def index
     # should show locations that a signed in user has access to, or redirect to sign-in page
    @locations = Location.all
  end


  private
    def location_params
      params.require(:location).permit(:name, :access_group_id)
    end
end
