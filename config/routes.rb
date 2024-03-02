Rails.application.routes.draw do
  get 'libraries/index'
  get 'flashcards/index'
  get 'stories/show'
  devise_for :users
  root to: "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check
  get 'stories', to: 'stories#index'
  resources :stories, only: [:new, :create, :show] do
    resources :story_segments, only: [:create]
  end
  resources :flashcards, except: [:create]
  resources :story_segments, only: [:show] do
    resources :flashcards, only: [:create]
  end
end
