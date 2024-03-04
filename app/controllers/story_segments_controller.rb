require "json"

class StorySegmentsController < ApplicationController
  def index
    @story_segments = StorySegment.all
  end

  def show
    @story_segment = StorySegment.find(params[:id])

    # @message_hash = JSON.parse(@story_segment.message)
    # @paragraphs = @message_hash["paragraphs"]
    # @segment_num = @message_hash["segment"]
    # @choices = @message_hash["choices"]

    # @pagy, @paragraphs = pagy(@parsed_segment["paragraphs"])
    # @parsed_segment = JSON.parse(@story_segment.message)
    @paragraphs = @story_segment.safe_message["paragraphs"]
    @segment_num = @story_segment.safe_message["segment"]
    @choices = @story_segment.safe_message["choices"]

    # @textbits = StorySegment.where("id LIKE ?", params[:id])
    # raise
    @paragraphs = @paragraphs
  end

  def create
    story_segment = StorySegment.find(params["story_segment"]["previous_story_segment_id"])
    story = story_segment.story
    choice = params["story_segment"]["choice"]
    user_segment = StorySegment.create!({story: story, order: story_segment.order + 1, message: choice, role: "user"})
    new_segment = StorySegment.new({story: story})
    if new_segment.save!
      CreateNewSegmentJob.perform_later({new_segment_id: new_segment.id, story_id: story.id, order: story_segment.order + 2})
      redirect_to loading_screens_path({segment_id: new_segment.id})
    else
      render :show, status: :unprocessable_entity
    end
    # big_bubba = []
    # segments = StorySegment.where(story_id: @story_segment.story_id)
    # segments.each do |segment|
    #   current_hash = {
    #     role: segment.role,
    #     content: segment.message,
    #   }
    #   big_bubba << current_hash
    # end
    # last_hash = {
    #   role: "user",
    #   content: params["story_segment"]["choice"],
    # }
    # big_bubba << last_hash
    # segment_message = OpenaiService.new(big_bubba).add_segment_call
    # segment_params = {
    #   order: @story_segment.order + 1,
    #   message: segment_message,
    #   role: 'assistant',
    #   story: @story_segment.story
    # }
    # new_segment = StorySegment.new(segment_params)
    # img_prompt = new_segment.first_paragraph
    # new_segment.set_photo(img_prompt)
    # new_segment.save!
    redirect_to story_segment_path(new_segment)
  end

  private

  def story_segment_params
    params.require(:story_segment).permit(:choice, :order)
  end
end
