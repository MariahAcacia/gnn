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

    def company_search(query)
      if query
        query = query.downcase
        where("LOWER(company_name) LIKE ?
               OR LOWER(name) LIKE ?
               OR LOWER(url) LIKE ?
               OR LOWER(blurb) LIKE ?
               OR LOWER(twitter) LIKE ?
               OR LOWER(instagram) LIKE ?
               OR LOWER(facebook) LIKE ?
               OR LOWER(email) LIKE  ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
      else
        where("")
      end
    end

  end

end
