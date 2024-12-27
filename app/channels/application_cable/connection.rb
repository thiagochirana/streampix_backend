module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_resource

    def connect
      # Verifica o tipo de conexão baseado nos parâmetros
      if request.params[:donate_id].present?
        self.current_resource = find_verified_donate
      elsif request.params[:alert_id].present?
        self.current_resource = find_current_alert_id
      else
        Rails.logger.warn "Conexão rejeitada: sem parâmetros válidos"
        reject_unauthorized_connection
      end
    end

    private

      # Conexão via donate_id
      def find_verified_donate
        donate_id = request.params[:donate_id]
        donate = Donate.find_by(id: donate_id)
        return donate if donate

        Rails.logger.warn "Desconectando, donate_id inválido"
        reject_unauthorized_connection
      end

      # Conexão via alert_id
      def find_current_alert_id
        alert_id = request.params[:alert_id]
        alert = DonateConfiguration.find alert_id
        return alert if alert

        Rails.logger.warn "Desconectando, alert com id #{alert_id} não encontrado"
        reject_unauthorized_connection
      end
  end
end
