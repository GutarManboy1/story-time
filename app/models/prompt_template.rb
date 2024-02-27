class PromptTemplate < ApplicationRecord
  has_many :stories

  validates :prompt, presence: true
  validates :prompt_variable, presence: true
end
