class CreateSavedRecords < ActiveRecord::Migration[5.2]
  def up
    create_table :saved_records do |t|
      t.integer :user_id, foreign_key: true
      t.references :saveable, polymorphic: true

      t.timestamps
    end
    add_index :saved_records, :user_id
  end
  def down
    drop_table :saved_records
  end
end
