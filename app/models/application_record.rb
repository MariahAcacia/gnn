class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.newest_four
    self.order({ created_at: :desc }).limit(4)
  end

end
