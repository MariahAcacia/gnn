class CreateTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :texts do |t|
      t.string :headline, null: false
      t.string :blurb, null: false
      t.string :url, null: false 
      t.attachment :photo

      t.timestamps
    end
  end
end
