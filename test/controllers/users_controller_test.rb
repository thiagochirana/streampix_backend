require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    token = access_token_from_login_as(users(:one))
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  test "should get about me" do
    get me_url, headers: @headers
    assert_response :success
    assert JSON.parse(response.body)["nickname"]
    assert JSON.parse(response.body)["email"]
  end
end
