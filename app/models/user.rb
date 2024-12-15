class User < ApplicationRecord
  has_secure_password
  has_many :tokens, dependent: :destroy

  validates :nickname, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  normalizes :email, with: ->(e) { e.strip.downcase }
end
