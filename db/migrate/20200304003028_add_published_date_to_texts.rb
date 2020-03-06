class AddPublishedDateToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :published_date, :date
  end
end
