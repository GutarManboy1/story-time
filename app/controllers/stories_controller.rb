require 'json'

class StoriesController < ApplicationController
  def show
    @story = Story.find(params[:id])
    puts "this is inside of story"
    p @story
    big_bubba = []
    segments = StorySegment.where(story_id: @story)
    puts "these are the segments"
    p segments
    segments.each do |segment|
      puts "this is a segment"
      p segment
      current_hash = {
        role: segment.role,
        content: segment.message
      }
      puts "this is the current_hash"
      p current_hash
      big_bubba << current_hash
    end
    puts "this is big bubba hi"
    p big_bubba
    last_hash = {
      role: 'user',
      content: "1"
    }
    big_bubba << last_hash
    new_segment = OpenaiService.new(big_bubba).add_segment_call
    segment_data = JSON.parse(new_segment)
    @paragraph = segment_data["paragraphs"][0]
  end

  def index
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def create
    @template_object = PromptTemplate.last
    template_string = @template_object.prompt
    settings = {
    genre: params[:genre],
    length: params[:length],
    difficulty: params[:difficulty],
    themes: params[:themes]
    }
    prompt = make_story_prompt(template_string, settings)
    first_segment = OpenaiService.new(prompt).call
    segment_data = JSON.parse(first_segment)
    @story = Story.new()
    @story.title = segment_data["title"]
    @story.system_prompt = prompt
    @story.user = current_user
    @story.prompt_template = @template_object
    if @story.save!
      system_params = {
        order: 0,
        message: prompt,
        role: 'system',
        story: @story
      }
      StorySegment.create!(system_params)
      first_segment_params = {
        order: 1,
        message: first_segment,
        role: 'system',
        story: @story
      }
      StorySegment.create!(first_segment_params)
      redirect_to story_path(@story)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def make_story_prompt(template, settings) # genre, length, difficulty, themes

    difficulty = case settings[:difficulty]
                 when 'Beginner'
                   'B1'
                 when 'Intermediate'
                   'B2'
                 when 'Advanced'
                   'C1'
                 else
                   'B2' # the default behavior in case something goes wierd
                 end
    length = case settings[:length]
             when 'short'
               3
             when 'medium'
               4
             when 'long'
               5
             else
               4 # the default behavior in case something goes wierd
             end
    length_plus = length + 1
    length_plus_plus = length + 2
    length_minus = length - 1
    length_minus_minus = length - 2

    template_variables = {
      genre: settings[:genre],
      length: length,
      difficulty: difficulty,
      themes: settings[:themes],
      length_plus: length_plus,
      length_plus_plus: length_plus_plus,
      length_minus: length_minus,
      length_minus_minus: length_minus_minus
    }

    completed_template = template % template_variables
    return completed_template
  end
end
