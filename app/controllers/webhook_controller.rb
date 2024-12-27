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
        DonationAlertChannel.broadcast_to(donate, "alert_code_#{donate.value.to_s.gsub('.', '_')}")
      end
    end if params["pix"]

    render plain: "ok"
  end
end
