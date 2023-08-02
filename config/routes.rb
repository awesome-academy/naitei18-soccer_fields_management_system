Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, only: %i(show)
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :football_pitches do
      resources :bookings, only: %i(new create)
      member do
        get "time_booked_booking", to: "football_pitches#time_booked_booking"
      end
    end
    resources :football_pitch_types
    resources :bookings, only: %i(index show)
  end
end
