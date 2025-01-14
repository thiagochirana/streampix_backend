class AdminController < ApplicationController
  allow_to_admin_users

  def index
    render plain: "Hello #{current_user.nickname}!"
  end

  def dashboard
    donates = Donate.all.order(created_at: :desc)
    sum_donates = donates.sum(:value)
    sum_paids_donates = donates.paids.sum(:value)
    sum_not_paid = donates.non_paids.sum(:value)

    total_count_donates = donates.count
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    total_pages = (total_count_donates / per_page.to_f).ceil

    donates = donates.offset((page - 1) * per_page).limit(per_page)
    render json: {
      donates: donates.map { |d|
        {
          nickname: d.nickname,
          value: d.value,
          message: d.message
        }
      },
      total: sum_donates,
      total_paids: sum_paids_donates,
      total_non_paids: sum_not_paid,
      pagination: {
        current_page: page,
        per_page: per_page,
        total_pages: total_pages,
        total_records: total_count_donates
      }
    }
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

    conf = DonateConfiguration.find_by(user: current_user)

    params_body = {
      chave: conf.pix_key
    }

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

  def clean_all_webhook_configs
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

    efipay_delete = SdkRubyApisEfi.new(options)
    resp = efipay_delete.pixDeleteWebhook(params: params_body)

    render json: { message: resp }
  end
end
