require 'json'

class CreateNewSegmentJob < ApplicationJob  # this job will put together a running total of all chat messages and send it to the api to get back the next segment. It will then call create_art_prompt.
  queue_as :default

  def perform(input)
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Now entering CreateNewSegmentJob..."
    new_segment = StorySegment.find(input[:new_segment_id])
    story = Story.find(input[:story_id])
    big_bubba = []
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Fetching story segments for this story..."
    segments = StorySegment.where(story_id: story.id).sort_by(&:order)
    all_segments = segments
    segments.pop
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Assembling \"Big Bubba\"..."
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Bubba has #{segments.count} segments."
    segments.each_with_index do |segment, index|
      puts "MMMMMMMMMMMMMMMMMMMMMMMM Looking at hash number #{index}..."
      puts "MMMMMMMMMMMMMMMMMMMMMMMM Role is #{segment.role}"
      current_hash = {
        role: segment.role,
        content: segment.message
      }
      big_bubba << current_hash
    end  # Big Bubba loop end tag
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Big Bubba successfully created."
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Calling ChatGPT...."
    segment_message = OpenaiService.new(big_bubba).add_segment_call
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Response recieved from ChatGPT... parsing..."
    segment_data = JSON.parse(segment_message)
    puts "MMMMMMMMMMMMMMMMMMMMMMMM Validating response format..."

    failed_tries = 0
    if segment_data.key?("paragraphs") && segment_data["paragraphs"].kind_of?(Array) && segment_data["paragraphs"].length >= 2
      puts "MMMMMMMMMMMMMMMMMMMMMMMM Paragraphs are ok, checking for choices..."
      if segment_data.key?("choices")
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Choices found in GPT response... validating them..."
        if segment_data["choices"].kind_of?(Array) && segment_data["choices"].length == 2
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Choices are ok.  Story should continue."
          picture_segment = CreateNewArtJob.perform_now({paragraphs: segment_data["paragraphs"].join(" "), segment: new_segment})
          segment_params = {
            order: input[:order],
            message: segment_message,
            role: 'assistant'
          }
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Updating new segment in the database..."
          if picture_segment.update!(segment_params)
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Segment successfully updated."
            SegmentChannel.broadcast_to(picture_segment, { action: 'redirect', path: Rails.application.routes.url_helpers.story_segment_path(picture_segment) })
          else
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Failed to update new segment."
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Cleaning up user choice and unfinished segment creation..."
            all_segments.last.destroy
            all_segments.last.destroy
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleted."
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Exiting generation..."
            StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
            return
          end # segment update check  success/failure + handling
        else
          failed_tries += 1
          if failed_tries < 3
            puts "Choices are invalid... Asking ChatGPT to try again..."
            self.class.perform_now(input)
          else
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Doesn't look like ChatGPT is cooperating... Giving up.  Maybe try later?"
            puts "MMMMMMMMMMMMMMMMMMMMMMMM Cleaning up user choice and unfinished segment creation..."
            all_segments.last.destroy
            all_segments.last.destroy
            StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
            return
          end #choice validation failure handling end tag, retry/quit
        end # choices validation end tag pass/fail
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM No choices found, this will be the last segment."
        picture_segment = CreateNewArtJob.perform_now({paragraphs: segment_data["paragraphs"].join(" "), segment: new_segment})
        segment_params = {
          order: input[:order],
          message: segment_message,
          role: 'assistant'
        }
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Updating new segment in the database..."
        if picture_segment.update!(segment_params)
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Segment successfully updated."
          SegmentChannel.broadcast_to(picture_segment, { action: 'redirect', path: Rails.application.routes.url_helpers.story_segment_path(picture_segment) })
        else
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Failed to update new segment."
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Cleaning up user choice and unfinished segment creation..."
          all_segments.last.destroy
          all_segments.last.destroy
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Deleted."
          puts "MMMMMMMMMMMMMMMMMMMMMMMM Exiting generation..."
          StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
          return
        end # segment update check  success/failure + handling
      end #choices exist check end tag exist/don't exist
    else
      failed_tries += 1
      if failed_tries < 3
        puts "Paragraphs are invalid... Asking ChatGPT to try again..."
        self.class.perform_now(input)
      else
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Doesn't look like ChatGPT is cooperating... Giving up.  Maybe try later?"
        puts "MMMMMMMMMMMMMMMMMMMMMMMM Cleaning up user choice and unfinished segment creation..."
        all_segments.last.destroy
        all_segments.last.destroy
        StoryChannel.broadcast_to(story, { action: 'redirect', path: Rails.application.routes.url_helpers.story_path(story) })
        return
      end #failed  paragraph validation end tag retry/quit
    end # initial segment validation end tag (paragraph check) pass/fail
  end # def end tag
end # Class end tag
