class CreateNewSegmentJob < ApplicationJob  # this job will put together a running total of all chat messages and send it to the api to get back the next segment. It will then call create_art_prompt.
  queue_as :default

  def perform(*args)
    response = OpenaiService.new(prompt).call
  end
end
