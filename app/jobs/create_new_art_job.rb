class CreateNewArtJob < ApplicationJob #this job will take a set of paragraphs and form chatGPT instructions too tell it to summarize and make an appropriate Dall-E art prompt.  Use those instructions to call Dall-e.
  queue_as :default

  def perform(input) #input must be a hash with key/values -> {paragraphs: string, segment: instance}
    puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Now entering CreateNewArtJob"
    img_prompt = OpenaiService.new(input[:paragraphs]).generate_art_prompt
    puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Recieved img_prompt back from chatgpt."
    puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Calling Dall-E-3 with the prompt... hold please..."
    input[:segment].set_photo(img_prompt)
    puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Photo attached to instance. Returning the instance to the caller."
    return input[:segment]
  end
end
