class Flashcard < ApplicationRecord
  belongs_to :story_segment
  belongs_to :user
end
