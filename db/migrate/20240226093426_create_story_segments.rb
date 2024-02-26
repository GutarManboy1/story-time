class CreateStorySegments < ActiveRecord::Migration[7.1]
  def change
    create_table :story_segments do |t|
      t.integer :image
      t.integer :order
      t.integer :message
      t.integer :role
      t.references :story_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
