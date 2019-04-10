class TextsController < ApplicationController

  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_text, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index]

  def index
    @lastest_texts = Text.newest_four
    @texts = Text.all.delete(@lastest_texts)
  end

  def show
  end

  def new
    @text = Text.new
  end

  def create
    @text = Text.new(text_params)
    if @text.save
      flash[:success] = "Text Article Added Successfully!"
      redirect_to texts_path
    else
      flash[:error] = "Unable to Add Text Article - See Form For Errors"
      render :new
    end
  end

  def edit
  end

  def update
    if @text.update(text_params)
      flash[:success] = "Text Article Updated Successfully!"
      redirect_to texts_path
    else
      flash[:error] = "Unable to Update Text Article - See Form For Errors"
      render :edit
    end
  end

  def destroy
    if @text.destroy
      flash[:success] = "Text Article Removed Successfully!"
    else
      flash[:error] = "Unable to Remove Text Article"
    end
    redirect_to texts_path
  end

  private

  def text_params
    params.require(:text).permit(:headline, :blurb, :url, :photo)
  end

  def set_text
    @text = Text.find(params[:id])
  end

end