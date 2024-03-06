require 'json'

class CreateNewStoryJob < ApplicationJob
  queue_as :default

  def perform(prompt, template, user_id, story_id)
    template_instance = PromptTemplate.find(template)
    user = User.find(user_id)
    story = Story.find(story_id)

    first_response = OpenaiService.new(prompt).call
    segment_data = JSON.parse(first_response)
    failed_tries = 0

    if segment_data.key?("title") &&
       segment_data.key?("paragraphs") &&
       segment_data.key?("choices") &&
       segment_data["paragraphs"].kind_of?(Array) &&
       segment_data["paragraphs"].length >= 2 &&
       segment_data["choices"].kind_of?(Array) &&
       segment_data["choices"].length == 2

      prompt_segment = StorySegment.create!({story: story})
      first_segment = StorySegment.create!({story: story})
      story.title = segment_data["title"]
      story.system_prompt = prompt
      if story.save!
        puts "MMMMMMMMMMMMMMMMMMMMMMMM New story successfully saved."
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Failed to save new story."
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Exiting generation..."
        StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.new_story_path })
        return
      end
      puts "MMMMMMMMMMMMMMMMMMMMMMMM Attempting to save system prompt (aka segment 0)..."
      prompt_segment.order = 0
      prompt_segment.message = prompt
      prompt_segment.role = "system"
      if prompt_segment.save!
        puts "MMMMMMMMMMMMMMMMMMMMMMMM System prompt (segment 0) successfully saved."
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Failed to save system prompt (segment 0)."
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleting attached story to clean up database..."
        story.destroy
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleted."
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Exiting generation..."
        StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.new_story_path })
        return
      end

      picture_segment = CreateNewArtJob.perform_now({paragraphs: segment_data["paragraphs"].join(" "), segment: first_segment})
      puts "MMMMMMMMMMMMMMMMMMMMMMMM  Returned from CreateNewArtJob."

      puts "MMMMMMMMMMMMMMMMMMMMMMMM Attempting to save first story segment (aka segment 1)..."
      picture_segment.order = 1
      picture_segment.message = first_response
      picture_segment.role = "assistant"
      if picture_segment.save!
        puts "MMMMMMMMMMMMMMMMMMMMMMMM First story segment (segment 1) successfully saved."
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Failed to save first story segment (segment 1)."
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleting system prompt segment and story to clean up database..."
        story.segments[0].destroy
        story.destroy
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleted."
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Exiting generation..."
        StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.new_story_path })
        return
      end

      StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
    else
      failed_tries += 1
      if failed_tries < 3
        puts "MMMMMMMMMMMMMMMMMMMMMMMM ChatGPT response was not in the correct format...(#{failed_tries.to_s} fails) requesting again... "
        self.class.perform_now(prompt, template, user_id, story_id)
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Doesn't look like ChatGPT likes this prompt... Giving up.  Try a different promt."
        StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.new_story_path })
      end
    end
  end
end

