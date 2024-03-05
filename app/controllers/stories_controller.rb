require "json"

class StoriesController < ApplicationController
  def show
    @story = Story.find(params[:id])
    @segments = StorySegment.where(story: @story).sort_by(&:order)
    @story_segment = @segments.last
    data = JSON.parse(@story_segment.message)
    @choices_exist = data.key?("choices")
  end

  def index
    @stories = Story.all
    @completed_stories = Story.all.reject do |story|
      story.story_segments.last.message["choices"]
    end
    @unfinished_stories = Story.all.select do |story|
      story.story_segments.last.message["choices"]
    end
  end

  def new
    @story = Story.new
  end

  def create
    template_object = PromptTemplate.last
    template_string = template_object.prompt
    settings = {
      genre: params[:genre],
      length: params[:length],
      difficulty: params[:difficulty],
      themes: params[:themes]
    }
    prompt = make_story_prompt(template_string, settings)
    new_story = Story.new({user: current_user, prompt_template: template_object})
    if new_story.save!
      CreateNewStoryJob.perform_later(prompt, template_object.id, current_user.id, new_story.id)
      redirect_to loading_screens_path({story_id: new_story.id})
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def make_story_prompt(template, settings) # genre, length, difficulty, themes
    difficulty = case settings[:difficulty]
      when "Beginner"
        "B1"
      when "Intermediate"
        "B2"
      when "Advanced"
        "C1"
      else
        "B2" # the default behavior in case something goes wierd
      end
    length = case settings[:length]
      when "short"
        3
      when "medium"
        4
      when "long"
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
      length_minus_minus: length_minus_minus,
    }

    completed_template = template % template_variables
    return completed_template
  end
end
