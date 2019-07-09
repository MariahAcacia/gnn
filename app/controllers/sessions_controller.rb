class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      if params[:remember_me]
        permanent_sign_in(@user)
      else
        sign_in(@user)
      end
      flash[:success] = "Welcome Back!"
    else
      flash[:error] = "Invalid User/Password Combination"
    end
    redirect_to root_path
  end

  def destroy
    sign_out
    flash[:success] = "You've successfully logged out"
    redirect_to root_path
  end


end
