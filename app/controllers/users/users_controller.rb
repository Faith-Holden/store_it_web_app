module Users
    class UsersController < ApplicationController

    skip_before_action :require_login, only: [:create, :new]
    before_action :crud_authorization, only: [:show, :edit, :update, :destroy]

    def create
      if logged_in?
        flash[:danger]= "You do not have permission to add other users."
        redirect_to root_url unless @current_user.is_sys_admin?
        return
      end
      @user = User.new(user_params)
      
      if @user.save
        UserPermission.new( user_id: @user.id).save
        @user.send_activation_email
        flash[:info]= "Please check your email for an activation link."
        render 'new'
      else
        redirect_to new_user_path
      end
    end

    def new
      if logged_in?
        unless @current_user.is_sys_admin?
          flash[:danger]= "You do not have permission to add other users."
          redirect_to root_url
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

    def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_path
    end

    def edit
      @user = User.find_by(id: params[:id])
    end

    def update
      user = User.find_by(id: params[:id])
      if user.update(user_params)
        flash[:success]= "User updated"
        redirect_to user
        return
      else
        redirect_to edit_user_path(user)
      end
    end

    
    private
      def user_params
        params.require(:user).permit(:name, :email, :password)
      end

      def crud_authorization
        unless current_user.is_sys_admin? || correct_user?
          flash[:danger]= "You do not have permission to create, update, or destroy other users."
          redirect_to root_url
        end
      end
  end
end