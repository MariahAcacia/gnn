module ApplicationHelper

  def signup_cancel_link
    if signed_in_admin?
      str = render partial: 'shared/admin_navbar'
    elsif signed_in_user?
      str = render partial: 'shared/logged_in_nav'
    elsif current_page?('/users/new')
      str = link_to "Cancel", root_path, class: 'nav-link'
    else
      str = link_to "Sign Up", new_user_path, class: 'nav-link signup-link'
    end
    str.html_safe
  end

  def login_logout_link
    if signed_in_user? || signed_in_admin?
      if @edit_page
        str = link_to "Cancel", user_path(current_user), class: 'nav-link cancel-link'
      else
        str = link_to "Logout", logout_path, class: "logout-link nav-link"
      end
    else
      str = link_to "Login", login_path, class: 'login-link nav-link'
    end
    str.html_safe
  end

  

end
