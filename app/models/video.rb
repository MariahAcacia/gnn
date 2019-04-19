class Video < ApplicationRecord

  validates :headline, :blurb, :url, presence: true

  has_attached_file :photo, styles: { thumb: '100x100', medium: '300x300' }
  
end
