class SessionsController < ApplicationController
  allow_unauthenticated_access

  def create
    user = User.authenticating(user_params)

    if user.is_a?(User) && user.errors.any?
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    elsif user
      render json: { access_token: gen_access_token(user), refresh_token: gen_refresh_token(user), message: "Logado com sucesso!" }
    else
      render json: { message: "Login e senha inválidos" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:login, :password, :password_confirmation)
  end
end
