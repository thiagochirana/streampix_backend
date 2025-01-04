# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:4200",
    "127.0.0.1:4200",
    "0.0.0.0:4200",
    "apis.devcurumin.com.br",
    "localhost:5000",
    "127.0.0.1:5000",
    "streampix.devcurumin.com.br"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true,
      expose: [ "access-token", "expiry", "token-type", "uid", "client" ]
  end
end
