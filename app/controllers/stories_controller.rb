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
    prompt = "You are a storyteller and you should present me with a ..." + parameters
    genre = params[:story][:prompt_template][:genre]
    length = params[:story][:prompt_template][:length]
    english_difficulty = params[:story][:prompt_template][:english_difficulty]
    keywords = params[:story][:prompt_template][:keywords]
    Story.create(
      system_prompt: prompt,
      title: "Sunshine Threads in Tokyo",
    )
  end
end
