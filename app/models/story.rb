class Story < ApplicationRecord
  belongs_to :user
  belongs_to :prompt_template

  validates :title, presence: true
  validates :system_prompt, presence: true
end
