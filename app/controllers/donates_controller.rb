class DonatesController < ApplicationController
  allow_unauthenticated_access only: [ :checkout ]

  def checkout
    begin
      ActiveRecord::Base.transaction do
        if !donate_params[:nickname].present? || donate_params[:nickname].length < 1
          render plain: "Quem é você? Preencha seu nickname", status: :bad_request
          return
        end

        if !donate_params[:value].present? || donate_params[:value].gsub(",", ".").to_f < 1.0
          render plain: "Donate não pode ser menor que 1 real", status: :bad_request
          return
        end

        char_limit = 200
        if !donate_params[:message].present? || donate_params[:message].length > char_limit
          render plain: "Mensagem não pode ter mais que #{char_limit} caracteres", status: :bad_request
          return
        end

        @donate = Donate.create!(
          nickname: donate_params[:nickname],
          value: donate_params[:value].gsub(",", ".").to_f,
          message: donate_params[:message]
        )
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
          donate_id: donate_generated.id,
          pix_copia_cola:,
          qr_code_svg: qr_svg
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      render plain: e.message, status: :bad_request
    rescue StandardError => e
      Rails.logger.error "Erro em processar o donate: #{e.message}"
      render plain: "Houve um erro interno, fale com o Curumin", status: :bad_request
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
