class VideosController < ApplicationController

  skip_before_action :require_login, only: [:index]
  before_action :require_admin, except: [:index, :show]
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video Article Added Successfully!"
      redirect_to videos_path
    else
      flash[:error] = "Unable to Add Video Article - See Forms For Errors"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @video.update(video_params)
      flash[:success] = "Video Article Updated Successfully!"
      redirect_to videos_path
    else
      flash[:error] = "Unable to Update Video Article - See Form For Errors"
      render :edit
    end
  end

  def destroy
    if @video.destroy
      flash[:success] = "Video Article Deleted Successfully!"
    else
      flash[:error] = "Unable to Delete Video Article"
    end
    redirect_to videos_path
  end

  private

  def video_params
    params.require(:video).permit(:headline, :blurb, :url, :photo)
  end

  def set_video
    @video = Video.find(params[:id])
  end

end
