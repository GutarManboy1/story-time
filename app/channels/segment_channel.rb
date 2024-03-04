class SegmentChannel < ApplicationCable::Channel
  def subscribed
    stream_for @segment
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
