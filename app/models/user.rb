class User < ApplicationRecord
  has_secure_password
  has_many :tokens, dependent: :destroy
  has_many :donates

  validates :nickname, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, if: :password_present?, on: :create
  validate :password_does_not_contain_invalid_characters

  def access_token
    tokens
      .where(token_type: "access", revoked: false)
      .where("expires_at > ?", Time.current).first
  end

  def refresh_token
    tokens
      .where(token_type: "refresh", revoked: false)
      .where("expires_at > ?", Time.current).first
  end

  def self.authenticating(params)
    user = new

    if params[:password] != params[:password_confirmation]
      user.errors.add(:base, "Senha e Confirmação de Senha estão diferentes")
      return user
    end

    if params[:login].include?("@")
      authenticate_by(email_address: params[:login], password: params[:password])
    else
      authenticate_by(nickname: params[:login], password: params[:password])
    end
  end

  private

  def password_present?
    password.present?
  end

  def password_does_not_contain_invalid_characters
    if password =~ /\s/
      errors.add(:password, "não pode conter espaços")
    end

    if password =~ /[áàãâäéèêëíìîïóòôõöúùûüçÇ]/
      errors.add(:password, "não pode conter acentos ou caracteres especiais como Ç")
    end
  end
end
