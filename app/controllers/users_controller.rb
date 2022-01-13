class UsersController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user, only: [:show, :index]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info]= "Please check your email for an activation link."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(params[:id])
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
