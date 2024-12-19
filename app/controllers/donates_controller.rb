class DonatesController < ApplicationController
  allow_unauthenticated_access only: [ :checkout ]

  def checkout
    begin
      ActiveRecord::Base.transaction do
        @donate = Donate.create!(donate_params)
        donate_generated = EfipayService.gen_new_payment(@donate)
        pix_copia_cola = donate_generated[:pix_copia_cola]

        qrcode = RQRCode::QRCode.new(pix_copia_cola)
        qr_svg = qrcode.as_svg(
          color: "000",                   # Cor do QR Code
          fill: "FFF",                    # Cor de fundo
          module_size: 8,                 # Tamanho de cada módulo
          use_path: true,                 # Renderizar com <path> para SVG menor
          viewbox: true                   # Ativa o atributo viewBox para responsividade
        ).to_s.gsub("<?xml version=\"1.0\" standalone=\"yes\"?>", "").html_safe

        render json: {
          pix_copia_cola:,
          qr_code_svg: qr_svg
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def token
    tkn = EfipayService.get_access_token
    render plain: tkn
  end

  private

    def donate_params
      params.require(:donate).permit(:nickname, :message, :value)
    end
end
