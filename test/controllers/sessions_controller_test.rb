require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @refresh_token = @user.refresh_token
  end

  test "should log in user with valid credentials" do
    post login_url, params: { login: @user.email, password: "password123" }
    assert_response :success
    assert JSON.parse(response.body)["access_token"]
  end

  test "should not log in user with invalid credentials" do
    post login_url, params: { login: @user.email, password: "wrongpassword" }
    assert_response :unauthorized
    assert_includes JSON.parse(response.body)["error"][0], "Login e senha inválidos"
  end

  test "should refresh token with valid refresh token" do
    user = authorize_user(@user)
    post refresh_url, headers: { Authorization: "Bearer #{user.refresh_token}" }
    assert_response :success
    assert JSON.parse(response.body)["access_token"][0]
  end

  test "should not refresh token with invalid refresh token" do
    post refresh_url, headers: { Authorization: "Bearer invalid_token" }
    assert_response :unauthorized
    assert_includes JSON.parse(response.body)["error"][0], "Token inválido"
  end
end
