class GivingsController < ApplicationController

  before_action :set_company, only: [:edit, :update, :show, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :search_index]

  def index
    @newest_givings = Giving.newest_four
    @givings = Giving.all - @newest_givings
  end

  def new
    @giving = Giving.new
  end

  def create
    @giving = Giving.new(giving_params)
    if @giving.save
      flash[:success] = "New Giving Option Added"
      redirect_to givings_path
    else
      flash[:error] = "Unable to Add New Giving Option - See Form For Errors"
      render :new
    end
  end

  def edit
  end

  def update
    if @giving.update(giving_params)
      flash[:success] = "Giving Option Successfully Updated!"
      redirect_to givings_path
    else
      flash[:error] = "Unable to Update Giving Option - See Form For Errors"
      render :edit
    end
  end

  def show
  end

  def destroy
    if @giving.destroy
      flash[:success] = "Giving Option DELETE Successfully (this action cannot be undone)"
    else
      flash[:error] = "Unable to DELETE Giving Option"
    end
    redirect_to givings_path
  end

  def search_index
    @givings = Giving.company_search(params[:giving_query])
  end


  private

  def giving_params
    params.require(:giving).permit(:company_name, :name, :url, :blurb, :photo, :twitter, :facebook, :instagram, :email)
  end

  def set_company
    @giving = Giving.find(params[:id])
  end
end
