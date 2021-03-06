class AccountActivationsController < ApplicationController
  skip_before_action :require_login
  def edit
    user = User.find_by(email: params[:email])
    debugger
    if user && !user.activated? && user.authenticated?("activation", params[:id])
      user.activate
      log_in user
      flash[:success] = "Account Activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid Activation Link!"
      redirect_to root_url
    end
  end
end
