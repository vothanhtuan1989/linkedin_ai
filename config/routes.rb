Rails.application.routes.draw do
  get 'chat_responses/show'
  get 'chats/index'
  get 'chat/index'

  resources :messages
  resources :connections
  resources :csv
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :chat_responses, only: [:show]

  # Defines the root path route ("/")
  root "chats#index"
end
