require 'json'

class CreateNewSegmentJob < ApplicationJob  # this job will put together a running total of all chat messages and send it to the api to get back the next segment. It will then call create_art_prompt.
  queue_as :default

  def perform(input)
    new_segment = StorySegment.find(input[:new_segment_id])
    story = Story.find(input[:story_id])
    big_bubba = []
    segments = StorySegment.where(story_id: story_id)
    segments.each do |segment|
      current_hash = {
        role: segment.role,
        content: segment.message
      }
      big_bubba << current_hash
    end
    segment_message = OpenaiService.new(big_bubba).add_segment_call
    segment_data = JSON.parse(segment_message)
    picture_segment = CreateNewArtJob.perform_now({paragraphs: segment_data["paragraphs"].join(" "), segment: new_segment})
    SaveNewSegmentJob.perform_now({order: 1, message: first_response, role: "assistant", segment: picture_segment})
    segment_params = {
      order: input[:order],
      message: segment_message,
      role: 'assistant',
      story: story
    }
    picture_segment.update!(segment_params)
    SegmentChannel.broadcast_to(segment, { action: 'redirect', path: Rails.application.routes.url_helpers.story_segment_path(picture_segment) })
  end
end
