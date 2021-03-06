class Video < ApplicationRecord

  include Searchable

  validates :headline, :blurb, :url, :source, :published_date, :author, presence: true
  validates :headline, length: { in: 5..40 }
  validates :blurb, length: { in: 5..200 }

  has_attached_file :photo, styles: { thumb: '75x75', medium: '300x300' }
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  has_many :saved_records, as: :saveable, dependent: :destroy
  has_many :user_saves, through: :saved_records, source: :user, dependent: :destroy

end
