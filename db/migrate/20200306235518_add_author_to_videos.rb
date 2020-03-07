class AddAuthorToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :author, :string
  end
end
