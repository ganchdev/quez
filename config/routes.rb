# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"
  scope controller: :auth do
    get "/auth", action: :new
    get "/auth/:provider/callback", action: :callback
    match :logout, action: :destroy, via: [:delete, :get]
  end

  resources :quizzes do
    member do
      post :play
    end
    resources :questions, except: :index do
      resources :answers, except: [:index, :show]
    end
  end

  resources :games, only: [:show] do
    member do
      get :host, path: "host"
      delete :quit, path: "quit"
      post :start, path: "start"
      get :next_question, path: "next_question"
      post :player_answer, path: "player_answer", to: "game_player_answers#create"
    end
  end

  get "/:key", to: "games#join", as: :join_game
end
