class PaymentStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "donate_status_#{params[:donate_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
