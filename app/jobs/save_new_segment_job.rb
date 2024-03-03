class SaveNewSegmentJob < ApplicationJob
  queue_as :default

  def perform(params)
      segment = params[:segment]
      segment.order = params[:order]
      segment.message = params[:message]
      segment.role = params[:role]
      if segment.save!
        puts "Segment #{segment.order} successfully saved."
      else
        puts "Failed to save segment #{segment.order}."
      end
  end
end
