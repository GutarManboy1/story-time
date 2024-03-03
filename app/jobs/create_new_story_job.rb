require 'json'

class CreateNewStoryJob < ApplicationJob
  queue_as :default

  def perform(prompt, template)
    template_instance = PromptTemplate.find(template)
    puts "Prompt template retrieved"
    first_response = OpenaiService.new(prompt).call  # the reason why the api call is here and not in create_new_segment is because the new story needs a title.
    puts "Recieved first story paragraphs from chatgpt"
    segment_data = JSON.parse(first_response)
    puts "Parsed the data from chatgpt"
    story = Story.new
    prompt_segment = StorySegment.new
    first_segment = StorySegment.new
    puts "created a new story, and two new segments (blank)"
    SaveNewStoryJob.perform_later({title: segment_data["title"], prompt: prompt, template: template_instance, story: story})
    puts "Sent off the job to save the new story (completion unknown)"
    SaveNewSegmentJob.perform_later({order: 0, message: prompt, role: "system", story: story, segment: prompt_segment})
    puts "Sent off the job to save the system segment (completion unknown)"
    puts "Next, will send off job to attach a photo to the second blank segment"
    picture_segment = CreateNewArtJob.perform_now(segment_data["paragraphs"].join(" "), segment: first_segment)
    puts "Recieved segment back with photo attached (hopefully)"
    SaveNewSegmentJob.perform_later({order: 1, message: first_response, role: "assistant", story: story, segment: picture_segment})
    puts "Sent off the job to save the first story segment (completion unknown)"
  end
end

------
new_segment = StorySegment.new(first_segment_params)
text = new_segment.all_paragraphs.join(" ")
img_prompt = OpenaiService.new(text).generate_art_prompt
new_segment.set_photo(img_prompt)
new_segment.save!
redirect_to story_path(@story)
