Rails.application.routes.draw do
  get "users/about_me"
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
      get "hello", to: "home#hello"
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
        post "/", to: "donates#checkout", as: :checkout
        get "/token", to: "donates#token", as: :token_efipay
      end
    end
  end
  scope :pix do
    
  end
end
