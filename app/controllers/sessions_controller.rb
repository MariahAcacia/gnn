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
      flash[:success] = "You've signed in successfully!"
      redirect_to root_path
    else
      flash[:error] = "Unable to sign in - see form for errors"
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = "You've successfully logged out"
    redirect_to root_path
  end


end
