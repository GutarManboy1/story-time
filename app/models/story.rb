class Story < ApplicationRecord
  belongs_to :user
  belongs_to :prompt_template

  attr_accessor :genre, :length, :english_difficulty, :keywords

  validates :title, presence: true
  validates :system_prompt, presence: true
end
