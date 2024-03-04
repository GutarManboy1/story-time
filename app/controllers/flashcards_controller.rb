class FlashcardsController < ApplicationController
  def index
    @flashcards = current_user.flashcards
    @story = Story.find_by(id: params[:story_id])
    if @story
      @flashcards = @flashcards.where(story_segment: @story.story_segments)

    end
    @search_query = params[:search_query]

    @flashcards = @flashcards.search(@search_query) if @search_query.present?
    @story_segments = StorySegment.where(id: @flashcards.pluck(:story_segment_id))
    @stories = Story.where(id: @story_segments.pluck(:story_id))
  end
end

  def show
    @flashcards = Flashcard.find(params[:id])
  end

  def new
    @flashcard = Flashcard.new
  end

  def create
    @flashcard = Flashcard.new(flashcard_params)
    if @flashcard.save!
      redirect_to flashcards_path
    else
      render 'new'
    end
  end

  private

  def flashcard_params
    params.require(:flashcard).permit(:answer)
  end
