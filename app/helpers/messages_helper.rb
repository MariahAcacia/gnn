module MessagesHelper

  def display_form
    if signed_in_user?
      str = render partial: 'user_new'
    else
      str = render partial: 'generic_new' 
    end
  end

end
