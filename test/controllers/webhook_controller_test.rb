require "test_helper"

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get configure_pix" do
    get webhook_configure_pix_url
    assert_response :success
  end

  test "should get confirm_pix" do
    get webhook_confirm_pix_url
    assert_response :success
  end

  test "should get list_all_configured" do
    get webhook_list_all_configured_url
    assert_response :success
  end

  test "should get delete_config" do
    get webhook_delete_config_url
    assert_response :success
  end
end
