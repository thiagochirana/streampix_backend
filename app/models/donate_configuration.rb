class DonateConfiguration < ApplicationRecord
  belongs_to :user
  before_create :generate_new_alert_access_key

  private

    def generate_new_alert_access_key
      self.alert_access_key = SecureRandom.hex(16)
    end
end
