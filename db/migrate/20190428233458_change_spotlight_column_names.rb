class ChangeSpotlightColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :spotlights, :first_name, :name
    remove_column :spotlights, :last_name
  end
end
