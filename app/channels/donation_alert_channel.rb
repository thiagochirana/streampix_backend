class DonationAlertChannel < ApplicationCable::Channel
  def subscribed
    if current_resource.is_a?(DonateConfiguration)
      stream_for current_resource
    else
      reject
    end
  end

  def unsubscribed
    # Cleanup quando desconectar
  end
end
