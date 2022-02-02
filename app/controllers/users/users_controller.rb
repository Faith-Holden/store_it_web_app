module Users
    class UsersController < ApplicationController

    skip_before_action :require_login, only: [:create, :new]

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
      @users = User.all
    end

    def destroy
      # 
    end

    private
      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
  end
end