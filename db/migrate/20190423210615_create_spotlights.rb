class CreateSpotlights < ActiveRecord::Migration[5.2]
  def change
    create_table :spotlights do |t|
      t.string :company_name
      t.string :first_name
      t.string :last_name
      t.string :url, null: false
      t.text :blurb, null: false
      t.attachment :photo
      t.string :twitter
      t.string :instagram
      t.string :facebook
      t.string :email 

      t.timestamps
    end
  end
end
