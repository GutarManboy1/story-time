class StorySegment < ApplicationRecord
  belongs_to :story

  has_many :flashcards
end
