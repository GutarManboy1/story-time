class SaveNewSegmentJob < ApplicationJob
  queue_as :default

  def perform(params)
      segment = params[:segment]
      segment.order = params[:order]
      segment.message = params[:message]
      segment.role = params[:role]
      segment.story = params[:story]
      if segment.save!
        puts "Segment #{order} successfully saved."
      else
        puts "Failed to save segment #{order}."
      end
  end
end
