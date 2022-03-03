class AccessGroups::UsersController < ApplicationController
  before_action :require_user_can_crud_user_access, only: [:destroy, :create, :new]
  
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

  def destroy
    unless @current_user.can_crud_user_access?(AccessGroup.find(params[:access_group_id]))
      flash[:danger]= "You do not have permission to remove users from this group!"
      redirect_to root_url
      return
    end
    UserAccess.where(user_id: params[:id])
              .find_by(access_group_id: params[:access_group_id])
              .destroy
    redirect_to access_group_users_path
  end

  private
    def require_user_can_crud_user_access
      access_group = AccessGroup.find(params[:access_group_id])
      unless @current_user.can_crud_user_access?(access_group)
        flash[:danger]= "You do not have permission to create or remove users in this group!"
        redirect_to access_group_path(access_group)
      end
    end
  
end