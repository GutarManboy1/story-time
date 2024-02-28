class FlashcardsController < ApplicationController
  def index
    @flashcards = Flashcard.all
  end
end
