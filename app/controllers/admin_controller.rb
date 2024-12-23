class AdminController < ApplicationController
  allow_to_admin_users

  def index
    render plain: "Hello #{current_user.nickname}!"
  end

  def list_all_routes_webhooks
    options = {
      client_id: EFIPAY_CLIENT_ID,
      client_secret: EFIPAY_CLIENT_SECRET,
      certificate: EFIPAY_CERTIFICATE,
      sandbox: SANDBOX
    }

    params = {
      inicio: "2024-12-01T00:00:35Z",
      fim: "2024-12-31T23:59:35Z"
    }

    efipay = SdkRubyApisEfi.new(options)
    response = efipay.pixListWebhook(params: params)
    render json: { webhooks: response["webhooks"] }
  end

  def create_webhook
    options = {
      client_id: EFIPAY_CLIENT_ID,
      client_secret: EFIPAY_CLIENT_SECRET,
      certificate: EFIPAY_CERTIFICATE,
      sandbox: SANDBOX,
      "x-skip-mtls-checking": "true"
    }

    params_body = {
      chave: EFIPAY_PIXKEY
    }

    # first, delete actual webhook
    efipay_delete = SdkRubyApisEfi.new(options)
    efipay_delete.pixDeleteWebhook(params: params_body)

    # after deleted, create a new
    body = {
      webhookUrl: "#{params["new_webhook_url"]}"
    }

    efipay_create = SdkRubyApisEfi.new(options)
    response = efipay_create.pixConfigWebhook(
      params: params_body,
      body: body
    )
    render json: { message: response }
  end
end
