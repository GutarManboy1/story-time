class SaveNewStoryJob < ApplicationJob
  queue_as :default

  def perform(details)
    story = details[:story]
    story.title = details[:title]
    story.system_prompt = details[:prompt]
    if story.save!
      puts "MMMMMMMMMMMMMMMMMMMMMM New story successfully saved."
    else
      puts "MMMMMMMMMMMMMMMMMMMMMMM Failed to save new story."
    end
  end
end
