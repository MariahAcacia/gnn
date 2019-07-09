class SavedRecord < ApplicationRecord

  belongs_to :user
  belongs_to :saveable, polymorphic: true, touch: true

  def self.top_saved_articles(resource)
    where(saveable_type: resource).select(:saveable_id).group(:saveable_id).having("count(*) > 1").size
  end

end
