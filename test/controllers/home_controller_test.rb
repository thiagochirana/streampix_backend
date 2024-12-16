require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    token = access_token_from_login_as(users(:one))
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  test "should get hello" do
    get hello_url, headers: @headers
    assert_response :success
  end
end
