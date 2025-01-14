class SessionsController < ApplicationController
  allow_unauthenticated_access

  def create
    user = User.authenticating(user_params)

    if user.is_a?(User) && user.errors.any?
      render json: { errors: user.errors.full_messages }, status: :unauthorized
    elsif user
      render json: { access_token: gen_access_token(user), refresh_token: gen_refresh_token(user), message: "Logado com sucesso!" }
    else
      render plain: "Login e senha inválidos", status: :unauthorized
    end
  end

  def refresh
    generate_new_access_token_by_refresh
  end

  private

  def user_params
    params.permit(:login, :password)
  end
end
