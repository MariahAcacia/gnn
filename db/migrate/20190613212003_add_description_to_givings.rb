class AddDescriptionToGivings < ActiveRecord::Migration[5.2]
  def up
    add_column :givings, :description, :text
  end
  def down
    remove_column :givings, :description, :text 
  end
end
