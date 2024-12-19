class PaymentStatusChannel < ApplicationCable::Channel
  def subscribed
    donate = Donate.find(params[:donate_id])
    stream_for donate
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
