class WebhookController < ApplicationController
  allow_unauthenticated_access only: [ :confirm_pix ]

  def confirm_pix
    params["pix"].each do |don|
      donate = Donate.find_by(txid: don["txid"])
      ActiveRecord::Base.transaction do
        donate.update!(
          end_to_end_id: don["endToEndId"],
          paid_at: don["horario"]
        )
        PaymentStatusChannel.broadcast_to(donate, "paid")

        donate_configuration = DonateConfiguration.find_by(pix_key: don["chave"])
        DonationAlertChannel.broadcast_to(donate_configuration, {
          nickname: donate.nickname,
          value: donate.value,
          message: donate.message
        })
      end
    end if params["pix"]

    render plain: "ok"
  end
end
