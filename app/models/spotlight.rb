class Spotlight < ApplicationRecord

  validates :blurb, :url, presence: true
  
end
