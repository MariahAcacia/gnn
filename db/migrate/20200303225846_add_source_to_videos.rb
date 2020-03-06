class AddSourceToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :source, :string
  end
end
