ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def access_token_from_login_as(user)
      post login_url, params: { login: user.nickname, password: "12345678", password_confirmation: "12345678" }
      user.access_token = response.parsed_body[:access_token]
      user.refresh_token = response.parsed_body[:refresh_token]
      response.parsed_body[:access_token]
    end

    def authorize_user(user)
      post login_url, params: { login: user.nickname, password: "12345678", password_confirmation: "12345678" }
      user.access_token = response.parsed_body[:access_token]
      user.refresh_token = response.parsed_body[:refresh_token]
      user
    end
  end
end
