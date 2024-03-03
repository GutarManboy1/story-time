class CreateNewArtJob < ApplicationJob #this job will take a set of paragraphs and form chatGPT instructions too tell it to summarize and make an appropriate Dall-E art prompt.  Use those instructions to call Dall-e.
  queue_as :default

  def perform(paragraph_string, segment_instance)
    puts "Now entering CreateNewArtJob"
    img_prompt = OpenaiService.new(paragraph_string).generate_art_prompt
    puts "Recieved img_prompt back from chatgpt."
    segment_instance.set_photo(img_prompt)
    puts "Photo attached to instance. Returning the instance to the caller."
    return segment_instance
  end
end
