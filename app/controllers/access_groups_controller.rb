class AccessGroupsController < ApplicationController
  before_action :logged_in_user, only:[:create, :index]
  def new
    # redirect unless user has admin access to the group that they are trying to subgroup
    @access_group = AccessGroup.new
  end

  def create
    # should redirect under same conditions as new
    # parent should be originating group by default
    @access_group = AccessGroup.new(group_params)
    if @access_group.save
      redirect_to @access_group
    else
      render 'new'
    end
  end

  def show
    #should redirect unless signed in with view + perms
    @access_group = AccessGroup.find(params[:id])
  end

  def index
    # should redirect under same conditions as show
    @access_groups = AccessGroup.all
  end

  private 
    def group_params
      params.require(:access_group).permit(:name, :parent)
    end

end
