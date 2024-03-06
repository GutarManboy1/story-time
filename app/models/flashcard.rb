class Flashcard < ApplicationRecord
  belongs_to :story_segment
  belongs_to :user
  # belongs_to :story

  scope :search, ->(query) do
    begin
      date = Date.parse(query)
      rescue
        date = nil
    end

    if query.present?
      joins(story_segment: :story)
        .where('stories.title ILIKE :query OR flashcards.created_at = :date OR flashcards.excerpt ILIKE :query', query: "%#{query}%", date: date )
    else
      all
    end
  end
end
