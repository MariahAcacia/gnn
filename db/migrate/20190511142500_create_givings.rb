class CreateGivings < ActiveRecord::Migration[5.2]
  def change
    create_table :givings do |t|
      t.string :company_name
      t.string :name
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
