class AddAuthorToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :author, :string
  end
end
