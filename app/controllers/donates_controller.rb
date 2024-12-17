class DonatesController < ApplicationController
  allow_unauthenticated_access only: [ :checkout ]

  def checkout
    begin
      ActiveRecord::Base.transaction do
        @donate = Donate.create!(donate_params)

        donate_generated = EfipayService.gen_new_payment(@donate)

        qrcode = RQRCode::QRCode.new(donate_generated[:pix_copia_cola])
        qr_svg = qrcode.as_svg(
          color: "000",                   # Cor do QR Code
          fill: "FFF",                    # Cor de fundo
          module_size: 8,                 # Tamanho de cada módulo
          shape_rendering: "crispEdges",
          use_path: true,                 # Renderizar com <path> para SVG menor
          viewbox: true                   # Ativa o atributo viewBox para responsividade
        )

        render json: {
          donate: donate_generated,
          qr_code: qr_svg
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
