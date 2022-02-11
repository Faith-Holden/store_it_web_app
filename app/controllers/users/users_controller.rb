module Users
    class UsersController < ApplicationController

    skip_before_action :require_login, only: [:create, :new]
    before_action :crud_authorization, only: [:edit, :update, :destroy]

    def create
      if logged_in?
        redirect_to root_url unless @current_user.is_sys_admin?
      end
      @user = User.new(user_params)
      
      if @user.save
        UserPermission.new( user_id: @user.id,
          is_sys_admin: false,
          can_crud_items: false,
          can_crud_locations_with_parent: false,
          can_crud_locations_no_parent: false).save
        @user.send_activation_email
        flash[:info]= "Please check your email for an activation link."
        redirect_to root_url
      else
        render 'new'
      end
    end

    def new
      if logged_in?
        unless @current_user.is_sys_admin?
          redirect_to root_url
          flash[:warning]= "You do not have permissions for adding other users."
        end
      end
      @user = User.new
    end

    def show
      @user = User.find(params[:id])
      unless @user.activated?
        flash[:warning] = "Account not activated."
        redirect_to root_url
      end
    end

    def index
      redirect_to root_url unless @current_user.is_sys_admin?
      @users = User.all
    end

    def destroy #permission managed by before_action
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end

    def edit
      @user = User.find_by(id: params[:id])
    end

    def update
      @user = User.find_by(id: params[:id])
      if @user.update(user_params)
        flash[:success]= "User updated"
        redirect_to @user
      else
        render 'edit'
      end
    end

    
    private
      def user_params
        params.require(:user).permit(:name, :email, :password)
      end

      def crud_authorization
        unless @current_user.is_sys_admin? || correct_user?
          redirect_to root_url
          return
        end
      end
  end
end