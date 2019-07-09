class UsersController < ApplicationController

  before_action :require_admin, only: [:admin_show]
  before_action :require_current_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:home, :new, :create, :search_all]

  def home
    @texts = Text.newest_four
    @videos = Video.newest_four
    @spotlights = Spotlight.newest_four
    @givings = Giving.newest_four
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
    @user = User.find(params[:id])
    @texts = @user.get_saved("Text")
    @videos = @user.get_saved("Video")
    @spotlights = @user.get_saved("Spotlight")
    @gygos = @user.get_saved("Giving")
  end

  def admin_panel
    @administrator
    @saved_text = SavedRecord.top_saved_articles("Text")
    @saved_video = SavedRecord.top_saved_articles("Video")
    @saved_spotlight = SavedRecord.top_saved_articles("Spotlight")
    @saved_giving = SavedRecord.top_saved_articles("Giving")
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

  def search_all
    @texts = Text.article_search(params[:search_query])
    @videos = Video.article_search(params[:search_query])
    @spotlights = Spotlight.company_search(params[:search_query])
    @givings = Giving.company_search(params[:search_query])
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
