Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
      scope :auth do
        post "login", to: "sessions#create"
        post "login/refresh", to: "sessions#refresh"
      end
    end
  end
end
