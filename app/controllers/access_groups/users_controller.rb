class AccessGroups::UsersController < ApplicationController
  def index
    @access_group = AccessGroup.find(params[:access_group_id])
    if @current_user.is_sys_admin? || @current_user.can_crud_user_access?(@access_group)
      @users = @access_group.users
    else
      redirect_to @access_group
      flash[:warning]= "You do not have access to the users in this group!"
    end
  end

  def new
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def create
    @user = User.find(params[:user_id])
    @access_group = AccessGroup.find(params[:access_group_id])
    @access_group.add_user(@user)
    redirect_to access_group_users_path(@access_group)
  end
end