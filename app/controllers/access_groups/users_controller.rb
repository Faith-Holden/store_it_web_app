class AccessGroups::UsersController < ApplicationController
  before_action :require_user_can_crud_user_access, only: [:destroy, :create, :new, :edit, :update]
  
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

  def edit
    @user = User.find(params[:id])
    @access_group = AccessGroup.find(params[:access_group_id])
  end

  def update
    @access_group = AccessGroup.find(params[:access_group_id])
    user = User.find_by(id: params[:id])
    if @current_user.is_group_admin?(@access_group) || @current_user.is_sys_admin?
      user.set_user_access_permissions(@access_group, UserAccess.get_permission_level(params[:access_level]))
    end

    redirect_to @access_group
  end

  def destroy
    access_group = AccessGroup.find_by(id: params[:access_group_id])
    user = User.find_by(id: params[:id])
    access_group.remove_user(user)
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