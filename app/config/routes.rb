Rails.application.routes.draw do
  root "home#index"

  get "forecast", to: "weather#show"

  get "up" => "rails/health#show", as: :rails_health_check
end
