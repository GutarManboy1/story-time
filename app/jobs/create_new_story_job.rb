require 'json'

class CreateNewStoryJob < ApplicationJob
  queue_as :default

  def perform(prompt, template, user_id, story_id)
    template_instance = PromptTemplate.find(template)
    user = User.find(user_id)
    story = Story.find(story_id)
    sleep 5

    first_response = OpenaiService.new(prompt).call
    segment_data = JSON.parse(first_response)

    prompt_segment = StorySegment.create!({story: story})
    first_segment = StorySegment.create!({story: story})
    p first_segment

    SaveNewStoryJob.perform_now({title: segment_data["title"], prompt: prompt, story: story})
    puts "MMMMMMMMMMMMMMMMMMMMMMM Returned from SaveNewStoryJob"
    SaveNewSegmentJob.perform_now({order: 0, message: prompt, role: "system", segment: prompt_segment})
    puts "MMMMMMMMMMMMMMMMMMMMMMMM  Returned from SaveNewSegmentJob (first time)"
    picture_segment = CreateNewArtJob.perform_now({paragraphs: segment_data["paragraphs"].join(" "), segment: first_segment})
    p picture_segment
    p picture_segment.photo.attached?
    puts "MMMMMMMMMMMMMMMMMMMMMMMM  Returned from CreateNewArtJob."
    SaveNewSegmentJob.perform_now({order: 1, message: first_response, role: "assistant", segment: picture_segment})
    puts "MMMMMMMMMMMMMMMMMMMMMMMM   Returned from SaveNewSegmentJob (second time)"

    StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
  end
end

# ------
# new_segment = StorySegment.new(first_segment_params)
# text = new_segment.all_paragraphs.join(" ")
# img_prompt = OpenaiService.new(text).generate_art_prompt
# new_segment.set_photo(img_prompt)
# new_segment.save!
# redirect_to story_path(@story)
#the has here gets passed to the action cable payload, generally this is a hash (it could be other things but there is little point to do so)
