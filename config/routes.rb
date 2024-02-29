Rails.application.routes.draw do
  get 'libraries/index'
  get 'flashcards/index'
  get 'stories/show'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get 'stories', to: 'stories#index'
  resources :stories, only: [:new, :create, :show]
  resources :flashcards, except: [:create]
  resources :story_segments, only: [] do
    resources :flashcards, only: [:create]
  end

end
