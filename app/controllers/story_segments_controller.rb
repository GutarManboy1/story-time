require "json"

class StorySegmentsController < ApplicationController
  def index
    @story_segments = StorySegment.all
  end

  def show
    @story_segment = StorySegment.find(params[:id])

    @next_segment = @story_segment.story.story_segments.find_by(order: (@story_segment.order + 2))
    @choices = @story_segment.safe_message["choices"]
    unless @next_segment.present?
      if @choices.present?
        story = @story_segment.story
        # path_one_user_segment = StorySegment.new({story: story, order: story_segment.order + 1, message: "1", role: "user"})
        CreateNewSegmentJob.perform_later({user_choice: 1, story_id: story.id, root_segment_id: @story_segment.id})
        # path_two_user_segment = StorySegment.new({story: story, order: story_segment.order + 1, message: "2", role: "user"})
        CreateNewSegmentJob.perform_later({user_choice: 2, story_id: story.id, root_segment_id: @story_segment.id})
      end
    end
      # choice_one_segment = CreateNewSegmentJob.perform_later({new_segment_id: new_segment.id, story_id: story.id, order: story_segment.order + 2})
      # choice_two_segment =
    # @story_segment.next_segment is ideal
    # @pagy, @paragraphs = pagy(@parsed_segment["paragraphs"])
    # @parsed_segment = JSON.parse(@story_segment.message)
    @paragraphs = @story_segment.safe_message["paragraphs"]
    @segment_num = @story_segment.safe_message["segment"]


    # @textbits = StorySegment.where("id LIKE ?", params[:id])
    # raise
    @paragraphs = @paragraphs
  end

  def create
    story_segment = StorySegment.find(params["story_segment"]["previous_story_segment_id"])
    story = story_segment.story
    choice = params["story_segment"]["choice"]
    user_segment = StorySegment.create!({story: story, order: story_segment.order + 1, message: choice, role: "user"})
    new_segment = StorySegment.new({story: story, order: story_segment.order + 2})
    if new_segment.save!
      CreateNewSegmentJob.perform_later({new_segment_id: new_segment.id, story_id: story.id})
      redirect_to loading_screens_path({segment_id: new_segment.id})
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def story_segment_params
    params.require(:story_segment).permit(:choice, :order)
  end
end
