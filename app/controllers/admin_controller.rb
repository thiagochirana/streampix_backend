class AdminController < ApplicationController
  def index
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
    render json: { webhooks: response }
  end
end
