class PaymentStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "donation_status_#{params[:donation_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
