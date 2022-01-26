class AccessGroupsController < ApplicationController
  def new
    # redirect unless user has admin access to the group that they are trying to subgroup
    @access_group = AccessGroup.new
    @current_user = current_user
    @access_groups = @current_user.groups_user_can_crud_subgroup
  end

  def create
    @access_group = AccessGroup.new(group_params)
    if @access_group.save
      redirect_to @access_group
    else
      render 'new'
    end
  end

  def show
    @access_group = AccessGroup.find(params[:id])
    if @current_user.can_see_locations_in_group?(@access_group)
      @locations = @access_group.locations
    end
  end

  def index
    @access_groups = @current_user.access_groups
  end

  def items
    @access_group = AccessGroup.find(params[:id])
    if @current_user.is_sys_admin? || @current_user.can_see_items_in_group?(@access_group)
      @items = @access_group.items
    end
  end

  def locations
    @access_group = AccessGroup.find(params[:id])
    if @current_user.is_sys_admin? || @current_user.can_see_locations_in_group?(@access_group)
      @locations = @access_group.locations
    end
  end

  def users
    @access_group = AccessGroup.find(params[:id])
    if @current_user.is_sys_admin? || @current_user.can_crud_user_access?(@access_group)
      @users = @access_group.users
    else
      redirect_to @access_group
      flash[:warning]= "You do not have access to the users in this group!"
    end
  end

  private 
    def group_params
      params.require(:access_group).permit(:name, :parent_id)
    end

end
