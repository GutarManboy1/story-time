Rails.application.routes.draw do
  get 'libraries/index'
  get 'flashcards/index'
  get 'stories/show'
  devise_for :users
  root to: "pages#home"
  get 'main', to: 'pages#main'
  get "up" => "rails/health#show", as: :rails_health_check
  get 'stories', to: 'stories#index'
  get 'loading_screens', to: 'loading_screens#index'
  get 'test', to: 'loading_screens#test'
  resources :stories, only: [:new, :create, :show] do
    resources :story_segments, only: [:create]
    resources :flashcards, only: [:index]
  end
  resources :flashcards, except: [:create, :show]
  resources :story_segments, only: [:show] do
    resources :flashcards, only: [:create]
  end
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
