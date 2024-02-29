require "json"

class StorySegmentsController < ApplicationController
  def index
    @story_segments = StorySegment.all
  end

  def show
    @story_segment = StorySegment.find(params[:id])
    # @pagy, @paragraphs = pagy(@parsed_segment["paragraphs"])
    # @parsed_segment = JSON.parse(@story_segment.message)
    @paragraphs = @story_segment.safe_message["paragraphs"]
    @segment_num = @story_segment.safe_message["segment"]
    @choices = @story_segment.safe_message["choices"]
    # @textbits = StorySegment.where("id LIKE ?", params[:id])
    # raise
    @pagy_a, @paragraphs = pagy_array(@paragraphs, items: 1)
  end

  def create
    @story_segment = StorySegment.find(params["story_segment"]["previous_story_segment_id"])
    big_bubba = []
    segments = StorySegment.where(story_id: @story_segment.story_id)
    segments.each do |segment|
      current_hash = {
        role: segment.role,
        content: segment.message,
      }
      big_bubba << current_hash
    end
    last_hash = {
      role: "user",
      content: params["story_segment"]["choice"],  # TODO: get the choice from the user and put it inside the quotes
    }
    big_bubba << last_hash
    new_segment = OpenaiService.new(big_bubba).add_segment_call
    segment_data = JSON.parse(new_segment)
    # @paragraph = segment_data["paragraphs"][0]       use this if you wanna check if there is anything inside of the data
  end

  private

  def story_segment_params
    params.require(:story_segment).permit(:choice, :order)
  end
end
