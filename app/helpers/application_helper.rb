module ApplicationHelper

  def signup_cancel_link
    if signed_in_admin?
      str = render partial: 'shared/admin_navbar'
    elsif signed_in_user?
      str = render partial: 'shared/logged_in_nav'
    elsif current_page?('/users/new')
      str = link_to "Cancel", root_path, class: 'cancel-link nav-link'
    else
      str = link_to "Sign Up", new_user_path, class: 'signup-link nav-link'
    end
    str.html_safe
  end

  def login_logout_link
    if signed_in_user? || signed_in_admin?
      if @edit_page
        str = link_to "Cancel", user_path(current_user), class: 'cancel-link nav-link'
      end
    elsif current_page?('/login')
      str = link_to "Cancel", root_path, class: 'cancel-link nav-link'
    else
      str = link_to "Login", login_path, class: 'login-link nav-link'
    end
    str.html_safe
  end

  def article_action_links(article)
    if signed_in_user? && current_user.admin == false
      str = render partial: 'shared/save_unsave', locals: { article: article }
    elsif signed_in_admin?
      str = link_to "Delete", polymorphic_path(article), method: "DELETE", class: 'btn btn-secondary btn-sm delete-btn', data: { confirm: "Are you sure you want to delete this article? This action cannot be undone." }
      str2 = link_to "Edit", edit_polymorphic_path(article), class: 'btn btn-secondary btn-sm edit-btn'
    end
    safe_join([str, " ", str2])
  end

  def read_more_about_link(article)
    if article.class == Giving || article.class == Spotlight
      str = link_to "Read More About...", polymorphic_path(article), class: 'btn btn-secondary btn-sm show-btn' if article.description
    end
  end

  def save_remove_links (article, current_user)
    if saved?(article, current_user)
      str = link_to "Remove", saved_record_path( save: { user_id: current_user.id,
                                                     saveable_id: article.id,
                                                     saveable_type: article.class.to_s } ), method: :delete, class: 'btn btn-secondary btn-sm save-btn'
    else
      str = link_to "Save", saved_record_path( save: { user_id: current_user.id,
                                                   saveable_id: article.id,
                                                   saveable_type: article.class.to_s } ), method: :post, class: 'btn btn-secondary btn-sm save-btn'
    end
  end


end
