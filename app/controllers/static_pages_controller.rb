class StaticPagesController < ApplicationController

  skip_before_action :require_login, only: [:about, :contact]

  def about
  end

  def contact
  end


end
