class SavedRecord < ApplicationRecord

  belongs_to :user
  belongs_to :saveable, polymorphic: true, touch: true 

end
