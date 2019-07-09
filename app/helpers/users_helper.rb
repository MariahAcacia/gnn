module UsersHelper

  def article_count(resource)
    resource.constantize.count
  end

  def saved_article_count(resource)
    SavedRecord.where(saveable_type: resource).count
  end

end
