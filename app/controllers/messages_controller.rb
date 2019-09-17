class MessagesController < ApplicationController

  skip_before_action :require_login

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.valid?
      Message.delay.send_message(@message)
      flash[:success] = "Message sent successfully!"
      redirect_to root_path
    else
      flash[:error] = "Message not sent - see form for errors."
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:email, :name, :body)
  end

end
