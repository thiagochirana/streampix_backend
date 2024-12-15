module Authentication
  extend ActiveSupport::Concern

  SECRET_KEY = ENV["SECRET_KEY"] || Rails.application.secret_key_base

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  def gen_access_token(user)
    generate_jwt_for(user, "access", expiration_time: 15.minutes.from_now)
  end

  def gen_refresh_token(user)
    generate_jwt_for(user, "refresh", expiration_time: 2.days.from_now)
  end

  def generate_jwt_for(user, token_type, expiration_time:)
    tkn = (token_type == "access" ? user.access_token : user.refresh_token)
    return tkn.jwt if tkn

    jti = SecureRandom.uuid
    payload = {
      user_id: user.id,
      exp: expiration_time.to_i,
      jti: jti
    }

    token = JWT.encode(payload, SECRET_KEY, "HS256")

    Token.create!(
      user: user,
      jti: jti,
      jwt: token,
      token_type: token_type,
      expires_at: expiration_time
    )

    token
  end
  def current_user
    return @user if @user

    payload = decode_token_jwt
    @user = User.find_by(id: payload["user_id"]) if payload
    @user
  end

  def refresh_jwt
    refresh_token = token_jwt
    payload = JWT.decode(refresh_token, SECRET_KEY, true, algorithm: "HS256").first

    token = Token.find_by(jti: payload["jti"], token_type: "refresh")

    if token.nil? || token.revoked || token.expires_at < Time.current
      render json: { error: "Você não foi identificado, é necessário logar-se" }, status: :unauthorized
      return
    end

    new_access_token = gen_access_token(token.user)
    new_refresh_token = gen_refresh_token(token.user)

    token.update(revoked: true)

    render json: { access_token: new_access_token, refresh_token: new_refresh_token }, status: :ok
  end

  private

  def require_authentication
    current_user || request_need_authentication
  end

  def request_need_authentication
    render json: { error: "É necessário logar-se" }, status: :unauthorized
  end

  def decode_token_jwt
    unless token_jwt
      request_need_authentication
      return
    end

    begin
      decoded = JWT.decode(token_jwt, SECRET_KEY, true, algorithm: "HS256").first
      return unless validate_token_in_database(decoded) # Interrompe se inválido
      decoded
    rescue JWT::ExpiredSignature
      render json: { error: "Login expirado! Por favor faça login" }, status: :unauthorized
      nil
    rescue JWT::DecodeError
      render json: { error: "Erro ao lhe identificar, por favor, relogue" }, status: :unauthorized
      nil
    end
  end

  def validate_token_in_database(payload)
    token = Token.find_by(jti: payload["jti"], token_type: "access")

    if token.nil? || token.revoked || token.expires_at < Time.current
      render json: { error: "Token está inválido" }, status: :unauthorized
      return false
    end
    true
  end

  def token_jwt
    request.headers[:authorization]&.split(" ")&.last
  end

  def logout_jwt
    if current_user
      Token.where(user: current_user).update_all(revoked: true)
      render json: { message: "Você foi deslogado com sucesso" }, status: :ok
    else
      render json: { error: "Algo aconteceu e você não foi deslogado" }, status: :unauthorized
    end
  end
end
