class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.text :system_prompt
      t.text :title
      t.references :user_id, null: false, foreign_key: true
      t.references :prompt_template_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
