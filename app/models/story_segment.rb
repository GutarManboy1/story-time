class StorySegment < ApplicationRecord
  has_one_attached :photo

  belongs_to :story

  has_many :flashcards
end
