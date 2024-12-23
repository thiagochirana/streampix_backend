class DonationAlertChannel < ApplicationCable::Channel
  def subscribed
    alert = DonateConfiguration.find_by(alert_access_key: params[:alert_access_key])
    stream_from "alerts_#{alert.alert_access_key}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
