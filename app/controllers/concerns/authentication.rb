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

    def allow_to_admin_users(**options)
      before_action :require_admin_user
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
    return tkn.jwt if tkn.present? && !tkn.revoked && tkn.expires_at > Time.current

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

  def require_authentication
    return if current_user

    request_need_authentication
    nil
  end

  def require_admin_user
    false if current_user.role.admin?
  end

  def request_need_authentication
    render json: { error: "É necessário logar-se" }, status: :unauthorized unless response.body.present?
  end

  def decode_token_jwt
    unless token_jwt
      request_need_authentication
      return
    end

    begin
      decoded = JWT.decode(token_jwt, SECRET_KEY, true, algorithm: "HS256").first
      return unless validate_token_in_database(decoded)
      decoded
    rescue JWT::ExpiredSignature
      Token.find_by(jwt: token_jwt)&.update(revoked: true)
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
      token.update(revoked: true) if token.present?
      render json: { error: "Token está inválido" }, status: :unauthorized
      return false
    end
    true
  end

  def generate_new_access_token_by_refresh
    begin
      decoded_token = JWT.decode(token_jwt, SECRET_KEY, true, algorithm: "HS256").first
    rescue JWT::ExpiredSignature
      Token.find_by(jwt: token_jwt)&.update(revoked: true)
      render json: { error: "Login expirado! Por favor faça login" }, status: :unauthorized
      return
    rescue JWT::DecodeError
      render json: { error: "Erro ao lhe identificar, por favor, relogue" }, status: :unauthorized
      return
    rescue JWT::VerificationError
      render json: { error: "Não foi possível validar seu acesso, por favor, relogue" }, status: :unauthorized
      return
    end

    if decoded_token.nil? || decoded_token["jti"].nil?
      render json: { error: "Token inválido ou corrompido" }, status: :unauthorized
      return
    end

    token = Token.find_by(jti: decoded_token["jti"], token_type: "refresh")

    if token.nil? || token.revoked || token.expires_at < Time.current
      token.update(revoked: true) if token.present?
      render json: { error: "Realize novo login!" }, status: :unauthorized
      return
    end

    user = token.user
    user.access_token.update(revoked: true)

    render json: { access_token: gen_access_token(user), message: "Novo token gerado!" }
  end


  def token_jwt
    request.headers[:authorization]&.split(" ")&.last
  end

  def logout_jwt
    if current_user
      Token.where(user: current_user).update(revoked: true)
      render json: { message: "Você foi deslogado com sucesso" }, status: :ok
    else
      render json: { error: "Algo aconteceu e você não foi deslogado" }, status: :unauthorized
    end
  end
end
