class EfipayService
  include Env

  @options = {
    client_id: EFIPAY_CLIENT_ID,
    client_secret: EFIPAY_CLIENT_SECRET,
    certificate: EFIPAY_CERTIFICATE,
    sandbox: SANDBOX
  }

  def self.gen_new_payment(donate)
    body = {
      calendario: {
        expiracao: 300
      },
      valor: {
        original: sprintf("%.2f", donate.value)
      },
      chave: EFIPAY_PIXKEY,
      solicitacaoPagador: "Doação oríunda de livestream pelo usuário #{donate.nickname}"
    }

    efipay = SdkRubyApisEfi.new(@options)
    response = efipay.pixCreateImmediateCharge(body: body)

    donate.update(
      txid: response.dig("txid"),
      pix_copia_cola: response.dig("pixCopiaECola"),
      expires_at: Time.current + response.dig("calendario", "expiracao").to_i, # Calcula o datetime
      qrcode: response.dig("location")
    )

    donate
  end

  def self.get_access_token
    cred = Rails.cache.read("efipay_token")
    if cred.present?
      Rails.logger.info "Encontrado efipay token em Cache"
      return cred
    else
      Rails.logger.info "Nada de token efipay encontrado em Cache, buscar outro na API"
    end

    client_id = EFIPAY_CLIENT_ID
    client_secret = EFIPAY_CLIENT_SECRET

    certfile = File.read(EFIPAY_CERTIFICATE)

    url = URI("#{EFIPAY_API_URL}/oauth/token")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.cert = OpenSSL::X509::Certificate.new(certfile)
    https.key = OpenSSL::PKey::RSA.new(certfile)

    request = Net::HTTP::Post.new(url)
    request.basic_auth(client_id, client_secret)
    request["Content-Type"] = "application/json"
    request.body = "{\r\n    \"grant_type\": \"client_credentials\"\r\n}"

    response = https.request(request)
    json_response = JSON.parse(response.body)

    Rails.cache.write("efipay_token", json_response["access_token"], expires_in: 5.minutes)
    json_response["access_token"]
  end
end
