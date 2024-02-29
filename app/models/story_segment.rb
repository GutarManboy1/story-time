require "open-uri"

class StorySegment < ApplicationRecord
  # after_save if: -> { saved_change_to_name? || saved_change_to_ingredients? } do
  #   set_content
  #   set_photo
  # end
  default_scope { order(order: :asc)}
  scope :from_ai, -> {where(role: :assistant)}
  scope :from_user, -> {where(role: :user)}
  has_one_attached :photo


  belongs_to :story
  has_many :flashcards


  def first_paragraph
    begin
      JSON.parse(self.message).fetch("paragraphs").first
    rescue
      nil
    end
  end

  def safe_message
      JSON.parse(message)
    rescue
      message
  end

  private

  def set_photo
    client = OpenAI::Client.new
    response = client.images.generate(parameters:
      {
        prompt: "Create an image of something awesome",
        size: "256x256"
      })

    url = response["data"][0]["url"]
    file = URI.open(url)

    photo.purge if photo.attached?
    photo.attach(io: file, filename: "ai_generated_image.png", content_type: "image/png")
    return photo
  end
end
