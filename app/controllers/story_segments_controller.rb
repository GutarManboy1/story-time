require "json"

class StorySegmentsController < ApplicationController
  def show
    @story_segment = StorySegment.find(params[:id])
    @parsed_segment = JSON.parse(@story_segment.message)
    @paragraphs = @parsed_segment["paragraphs"]
  end

  def create
    raise
  end

  private

  def story_segment_params
    params.require(:story_segment).permit(:)
  end
end
