class AddSourceToTexts < ActiveRecord::Migration[5.2]
  def change
    add_column :texts, :source, :string
  end
end
