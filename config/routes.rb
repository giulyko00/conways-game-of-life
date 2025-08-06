Rails.application.routes.draw do
  devise_for :users
  
  # Root route
  root "home#index"
  
  # Game routes - single game session approach
  get "game", to: "game#index"
  post "game/upload", to: "game#upload"
  post "game/next_generation", to: "game#next_generation"
  post "game/reset", to: "game#reset"
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
