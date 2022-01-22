class SessionsController < ApplicationController

  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        redirect_to @user
      else
        flash[:warning]= "Account is not yet activated. 
                          Please check your email for the activation link."
        render 'new'
      end
    else
      flash[:danger]= "Invalid username/pasword."
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
