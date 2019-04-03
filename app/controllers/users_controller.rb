class UsersController < ApplicationController

  before_action :require_current_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:home, :new, :create]


  def home
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      flash[:success] = "you are now signed up!"
      redirect_to current_user
    else
      flash[:error] = "Unable to Sign up - see form for errors"
      render :new
    end
  end

  def show
  end

  def edit
    @edit_page = true 
  end

  def update
    if current_user.update(user_params)
      flash[:success] = "User info updated successfully"
      redirect_to current_user
    else
      flash[:error] = "Unable to update user info - see form for errors"
      render :edit
    end
  end

  def destroy
    if current_user.delete
      flash[:success] = "You have successfully deleted your account"
      redirect_to root_path
    else
      flash[:error] = "There was an error and we are unable to delete your account"
      redirect_to user_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                 :first_name,
                                 :last_name,
                                 :password,
                                 :password_confirmation )
  end

end
