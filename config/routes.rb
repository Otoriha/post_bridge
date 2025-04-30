Rails.application.routes.draw do
  get "dashboard/index"
  get "omniauth_callbacks/github"
  get "omniauth_callbacks/twitter"
  get "omniauth_callbacks/failure"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "posts/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "dashboard#index"

  get "login" => "sessions#new", as: :login
  delete "logout" => "sessions#destroy", as: :logout

  get "auth/:provider/callback" => "omniauth_callbacks#callback"
  get "auth/failure" => "omniauth_callbacks#failure"

  get "dashboard" => "dashboard#index", as: :dashboard

  # 投稿関連のルーティングを追加
  resources :posts
end
