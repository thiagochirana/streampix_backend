Rails.application.routes.draw do
  root "home#joke"
  get "up" => "rails/health#show", as: :rails_health_check
  mount ActionCable.server => "/cable"

  scope :backend do
    get "/", to: "home#joke" # just joke
    scope :v1 do
      get "/", to: "home#joke" # just joke
      get "hello", to: "home#hello"
      scope :admin do
        get "/", to: "admin#index"
        get "/tts", to: "admin#generate_tts"
        scope :webhook do
          get "/", to: "admin#list_all_routes_webhooks"
          put "/", to: "admin#create_webhook"
          delete "/", to: "admin#clean_all_webhook_configs"
        end
      end
      scope :auth do
        scope :login do
          post "/", to: "sessions#create", as: :login
          post "refresh", to: "sessions#refresh"
        end
      end
      scope :register do
        get "me", to: "users#about_me"
        post "/", to: "registrations#create", as: :register
        put "reset_password", to: "registrations#reset_password"
        put "update", to: "registrations#update"
      end
      scope :donates do
        get "/", to: "donates#last_donates", as: :last_donates
        post "/", to: "donates#checkout", as: :checkout
      end
    end
  end
  scope :webhook do
    post "confirm", to: "webhook#confirm_pix"
  end
end
