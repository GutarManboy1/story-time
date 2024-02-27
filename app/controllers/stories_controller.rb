class StoriesController < ApplicationController
  def show
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def create
    prompt = "You are a storyteller and you should present me with a ..." + parameters

    Story.create(
      system_prompt: prompt,
      title: "Sunshine Threads in Tokyo"
    )
  end
end
