module Searchable

  extend ActiveSupport::Concern

  module ClassMethods

    def article_search(query)
      if query
        query = query.downcase
        where("LOWER(headline) LIKE ? OR LOWER(blurb) LIKE ? OR LOWER(url) LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
      else
        where("")
      end
    end
  end

end
