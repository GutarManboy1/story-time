class LoadingScreensController < ApplicationController
  def index
    @story = params[:story_id].present? ? Story.find(params[:story_id]) : nil
    @segment = params[:segment_id].present? ? StorySegment.find(params[:segment_id]) : nil
  end

  def test
    StoryChannel.broadcast_to(Story.last, {test: "something"}.to_json)
  end
end
