module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_payment

    def connect
      self.current_payment = find_verified_payment
    end

    private
      def find_verified_payment
        if payment = Donate.find(params[:donate_id])
          payment
        else
          reject_unauthorized_connection
        end
      end
  end
end
