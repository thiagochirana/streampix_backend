module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_donate

    def connect
      self.current_donate = find_verified_donate
    end

    private

    def find_verified_donate
      donate_id = request.params[:donate_id]
      if donate_id && (donate = Donate.find_by(id: donate_id))
        donate
      else
        puts "Desconectando, não foi encontrado donate_id correto"
        reject_unauthorized_connection
      end
    end
  end
end
