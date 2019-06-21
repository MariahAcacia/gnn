class AddTextToSpotlight < ActiveRecord::Migration[5.2]
  def up
    add_column :spotlights, :description, :text
  end
  def down
    remove_column :spotlights, :description, :text
  end 
end
