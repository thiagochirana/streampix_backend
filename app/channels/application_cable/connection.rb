module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_payment

    def connect
      self.current_payment = find_verified_payment
    end

    private
      def find_verified_payment
        if (donate_id = request.params[:donate_id]) && (payment = Donate.find_by(id: donate_id))
          payment
        else
          reject_unauthorized_connection
        end
      end
  end
end
