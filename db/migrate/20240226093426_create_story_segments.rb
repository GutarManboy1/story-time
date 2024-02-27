class CreateStorySegments < ActiveRecord::Migration[7.1]
  def change
    create_table :story_segments do |t|
      t.string :image
      t.integer :order
      t.text :message
      t.string :role
      t.references :story_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
