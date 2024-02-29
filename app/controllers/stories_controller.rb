class StoriesController < ApplicationController
  def show
    @stories = Story.all
  end

  def index
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def create
    template_object = PromptTemplate.last
    template_string = template_object.template
    settings = {
    genre: params[:genre],
    length: params[:length],
    difficulty: params[:difficulty],
    themes: params[:themes]
    }
    prompt = make_story_prompt(template_string, settings)
    p prompt

    # Story.create(
    #   system_prompt: prompt,
    #   title: "Sunshine Threads in Tokyo",
    # )
  end

  private

  def make_story_prompt(template, settings) # genre, length, difficulty, themes

    difficulty = case settings[:difficulty]
                 when 'Beginner'
                   "B1"
                 when 'Intermediate'
                   "B2"
                 when 'Advanced'
                   "C1"
                 else
                   "B2" # the default behavior in case something goes wierd
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

    completed_template = template % { genre: settings[:genre], length: length, difficulty: difficulty, themes: settings[:themes], length_plus: length_plus, length_plus_plus: length_plus_plus, length_minus: length_minus, length_minus_minus: length_minus_minus }
    return completed_template
  end
end
