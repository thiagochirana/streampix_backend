class WebhookController < ApplicationController
  allow_unauthenticated_access only: [ :confirm_pix ]
  include Env

  def configure_pix
    options = {
      client_id: EFIPAY_CLIENT_ID,
      client_secret: EFIPAY_CLIENT_SECRET,
      certificate: EFIPAY_CERTIFICATE,
      sandbox: SANDBOX,
      "x-skip-mtls-checking": "true"
    }

    params = {
      chave: EFIPAY_PIXKEY
    }

    body = {
      webhookUrl: "#{WEBHOOK_URL}"
    }

    efipay = SdkRubyApisEfi.new(options)
    response = efipay.pixConfigWebhook(params: params, body: body)
    render json: { message: response }
  end

  def confirm_pix
    return head :bad_request unless params[:pix].present?

    params[:pix][0].each do |don|
      donate = Donate.find_by(txid: don[:txid])
      ActiveRecord::Base.transaction do
        donate.update!(
          end_to_end_id: don[:endToEndId],
          paid_at: don[:horario]
        )
        PaymentStatusChannel.broadcast_to(donate, "paid")
      end
    end

    render plain: "ok"
  end

  def list_all_configured
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

  def delete_config
  end
end
