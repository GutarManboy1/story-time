class SaveNewStoryJob < ApplicationJob
  queue_as :default

  def perform(details)
    story = details[:story]
    story.title = details[:title]
    story.system_prompt = details[:prompt]
    story.user = current_user
    story.prompt_template = details[:template]
    if story.save!
      puts "New story successfully saved."
    else
      puts "Failed to save new story."
    end
  end
end
