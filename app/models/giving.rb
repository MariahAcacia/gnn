class Giving < ApplicationRecord

  include Searchable

  validates :blurb, :url, presence: true
  validates :blurb, length: { in: 10..350 }
  validates :company_name, presence: true, unless: ->(spotlight){spotlight.name.present?}
  validates :name, presence: true, unless: ->(spotlight){spotlight.company_name.present?}

  has_attached_file :photo, styles: { thumb: '100x100', medium: '300x300'}

end
