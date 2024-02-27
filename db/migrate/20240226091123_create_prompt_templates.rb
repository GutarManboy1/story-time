class CreatePromptTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :prompt_templates do |t|
      t.text :prompt
      t.string :prompt_variable

      t.timestamps
    end
  end
end
