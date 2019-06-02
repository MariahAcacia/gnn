class SavedRecordsController < ApplicationController

  def create
    @record = SavedRecord.new(save_params)
    if @record.save
      flash[:success] = "Article Saved!"
    else
      flash[:danger] = "Unable to Save"
    end
    redirect_back(fallback_location: user_path(current_user))
  end

  def destroy
    @record = SavedRecord.find_by(user_id: save_params[:user_id], saveable_id: save_params[:saveable_id], saveable_type: save_params[:saveable_type])
    if @record.destroy
      flash[:success] = "Article Removed"
    else
      flash[:danger] = "Unable to Remove Article"
    end
    redirect_back(fallback_location: user_path(current_user))
  end

  private

  def save_params
    params.require(:save).permit(:user_id, :saveable_id, :saveable_type)
  end

end
