class Text < ApplicationRecord

  include Searchable

  validates :headline, :blurb, :url, presence: true
  validates :headline, :blurb, length: { in: 5..200 }

  has_attached_file :photo, styles: { thumb: '100x100', medium: '300x300'}



end
