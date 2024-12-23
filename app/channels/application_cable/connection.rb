module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_resource

    def connect
      # Verifica o tipo de conexão baseado nos parâmetros
      if request.params[:donate_id].present?
        self.current_resource = find_verified_donate
      elsif request.params[:alert_access_key].present?
        self.current_resource = find_current_alert_access_key_alert
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

      # Conexão via alert_access_key
      def find_current_alert_access_key_alert
        access_key = request.params[:alert_access_key]
        alert = DonateConfiguration.find_by(alert_access_key: access_key)
        return alert if alert

        Rails.logger.warn "Desconectando, alert_access_key inválida"
        reject_unauthorized_connection
      end
  end
end
