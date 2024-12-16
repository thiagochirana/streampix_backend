require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    token = access_token_from_login_as(users(:one))
    @headers = { "Authorization" => "Bearer #{token}" }
  end

  test "should create user with valid params" do
    assert_difference "User.count", 1 do
      post register_url, params: { nickname: "TestUser", email: "test@example.com", password: "password123", password_confirmation: "password123" }, headers: @headers
    end
    assert_response :created
    assert JSON.parse(response.body)["message"]
  end

  test "should not create user with invalid params" do
    post register_url, params: { nickname: "TestUser", email: "test@example.com", password: "123", password_confirmation: "123" }, headers: @headers
    assert_response :bad_request
    assert_includes JSON.parse(response.body)["error"], "Nova senha não pode ter menos de 8 caracteres"
  end

  test "should update user" do
    put update_url, params: { nickname: "UpdatedNickname", email: "updated@example.com" }, headers: @headers
    assert_response :success
    assert_equal "UpdatedNickname", @user.reload.nickname
  end

  test "should not update user with invalid data" do
    put update_url, params: { nickname: "", email: "updated@example.com" }, headers: @headers
    assert_response :bad_request
    assert_includes JSON.parse(response.body)["error"], "Nickname can't be blank"
  end

  test "should not update password with space" do
    put reset_password_url, params: { old_password: "12345678", new_password: "123 456 78", confirm_new_password: "123 456 78" }, headers: @headers
    assert_response :bad_request
    assert_includes JSON.parse(response.body)["error"], "Password não pode conter espaços"
  end
end
