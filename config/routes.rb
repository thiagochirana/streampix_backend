Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  scope :backend do
    scope :v1 do
    end
  end
end
