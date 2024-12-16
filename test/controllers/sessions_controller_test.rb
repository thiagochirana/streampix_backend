require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @refresh_token = @user.refresh_token
  end

  test "should log in user with valid credentials" do
    post backend_v1_auth_login_url, params: { login: @user.email, password: "password123" }
    assert_response :success
    assert JSON.parse(response.body)["access_token"]
  end

  test "should not log in user with invalid credentials" do
    post backend_v1_auth_login_url, params: { login: @user.email, password: "wrongpassword" }
    assert_response :unauthorized
    assert_includes JSON.parse(response.body)["message"], "Login e senha inválidos"
  end

  test "should refresh token with valid refresh token" do
    post backend_v1_auth_refresh_url, headers: { Authorization: "Bearer #{@refresh_token}" }
    assert_response :success
    assert JSON.parse(response.body)["access_token"]
  end

  test "should not refresh token with invalid refresh token" do
    post backend_v1_auth_refresh_url, headers: { Authorization: "Bearer invalid_token" }
    assert_response :unauthorized
    assert_includes JSON.parse(response.body)["error"], "Token inválido"
  end
end