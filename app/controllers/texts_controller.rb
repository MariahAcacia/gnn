class TextsController < ApplicationController

  before_action :require_admin, except: [:index, :search_index, :show, :saved_index]
  before_action :set_text, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :search_index]

  def index
    @newest_texts = Text.newest_four
    @texts = (Text.all - @newest_texts).sort! { |a, b|  b.created_at <=> a.created_at }
  end

  def search_index
    @texts = Text.article_search(params[:text_query])
  end

  def saved_index
    @texts = current_user.get_saved("Text")
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
    params.require(:text).permit(:headline, :blurb, :url, :source, :published_date, :author, :photo)
  end

  def set_text
    @text = Text.find(params[:id])
  end

end
