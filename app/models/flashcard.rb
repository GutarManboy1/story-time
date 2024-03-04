class Flashcard < ApplicationRecord
  belongs_to :story_segment
  belongs_to :user

  scope :search, ->(query) do
    where('title LIKE :query OR date_created = :query', query: "%#{query}%") if query.present?
  end
end
