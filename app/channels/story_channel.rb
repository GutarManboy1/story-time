class StoryChannel < ApplicationCable::Channel
  def subscribed
    p @story = Story.find(params[:id])
    stream_for @story
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
