Rails.application.routes.draw do
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

      post "donates", to: "donates#checkout", as: :checkout
    end
  end
  scope :webhook do
    post "confirm", to: "webhook#confirm_pix"
    post "configure", to: "webhook#configure_pix"
    get "list", to: "webhook#list_all_configured"
    delete "delete_config", to: "webhook#delete_config"
  end
end
