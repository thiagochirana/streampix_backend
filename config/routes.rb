Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
      scope :auth do
        scope :login do
          post "/", to: "sessions#create"
          post "refresh", to: "sessions#refresh"
        end
      end
      scope :register do
        post "/", to: "registrations#create"
        post "reset_password", to: "registrations#reset_password"
        put "update", to: "registrations#update"
      end
    end
  end
end
