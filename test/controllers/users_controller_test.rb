require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get about_me" do
    get users_about_me_url
    assert_response :success
  end
end
