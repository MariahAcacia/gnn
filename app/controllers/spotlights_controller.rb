class SpotlightsController < ApplicationController

  skip_before_action :require_login, only: [:index, :search_index]
  before_action :require_admin, except: [:index, :search_index, :show]
  before_action :set_spotlight, only: [:show, :edit, :update, :destroy]

  def index
    @newest_spotlights = Spotlight.newest_four
    @spotlights = Spotlight.all - @newest_spotlights
  end

  def search_index
    @spotlights = Spotlight.company_search(params[:spotlight_query])
  end

  def new
    @spotlight = Spotlight.new
  end

  def create
    @spotlight = Spotlight.new(spotlight_params)
    if @spotlight.save
      flash[:success] = "New Spotlight Added Successfully!"
      redirect_to spotlights_path
    else
      flash[:error] = "Unable to Add New Spotlight - See Form For Errors"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @spotlight.update(spotlight_params)
      flash[:success] = "Spotlight Successfully Updated!"
      redirect_to spotlights_path
    else
      flash[:error] = "Unable to Update Spotlight - See Form For Errors"
      render :edit
    end
  end

  def destroy
    if @spotlight.destroy
      flash[:success] = "Spotlight Deleted Successfully!"
    else
      flash[:error] = "Unable to Delete Spotlight"
    end
    redirect_to spotlights_path
  end

  private

  def spotlight_params
    params.require(:spotlight).permit(:company_name,
                                              :name,
                                              :url,
                                              :blurb,
                                              :twitter,
                                              :facebook,
                                              :instagram,
                                              :email,
                                              :photo)
  end

  def set_spotlight
    @spotlight = Spotlight.find(params[:id])
  end
end
