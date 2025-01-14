class WebhookController < ApplicationController
  allow_unauthenticated_access only: [ :confirm_pix ]

  def confirm_pix
    Money.locale_backend = :currency
    Money.default_currency = :brl

    params["pix"].each do |don|
      donate = Donate.find_by(txid: don["txid"])
      ActiveRecord::Base.transaction do
        value = Money.from_amount(donate.value)

        message = "#{donate.nickname} doou #{value.format}: #{donate.message if donate.value > 3.0}"
        audio_donate = TtsService.text_to_speak(message, donate.voice_sellected || "Ricardo")

        # Converte o audio_stream para Base64 antes de salvar
        audio_base64 = Base64.strict_encode64(audio_donate.read)
        audio_donate.rewind  # Importante: reposiciona o ponteiro do stream

        donate.update!(
          end_to_end_id: don["endToEndId"],
          paid_at: don["horario"],
          audio_donate: audio_donate
        )

        PaymentStatusChannel.broadcast_to(donate, "paid")
        donate_configuration = DonateConfiguration.find_by(pix_key: don["chave"])

        # Envia o áudio em Base64
        DonationAlertChannel.broadcast_to(donate_configuration, {
          nickname: donate.nickname,
          value: donate.value,
          message: donate.message,
          audio_donate: audio_base64
        })
      end
    end if params["pix"]
    render plain: "ok"
  end
end
