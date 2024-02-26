class Flashcard < ApplicationRecord
  belongs_to :story_segment_id
  belongs_to :user_id
end
