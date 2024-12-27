class DonationAlertChannel < ApplicationCable::Channel
  def subscribed
    alert = DonateConfiguration.find params[:alert_id]
    stream_from "alert_#{alert.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
