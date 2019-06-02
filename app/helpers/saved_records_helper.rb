module SavedRecordsHelper

  def saved?(article, user)
    if SavedRecord.find_by( user_id: user.id, saveable_id: article.id, saveable_type: article.class.to_s )
      true
    else
      false
    end
  end

end
