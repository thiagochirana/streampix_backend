class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [ :create ]

  def create
    user = User.new(user_create_params)
    if user.save
      render json: { message: "você foi cadastrado com sucesso!" }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user
    if user.update(user_update_params)
      render json: { message: "você foi atualizado com sucesso!" }
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def reset_password
    user = current_user
  end

  private

    def user_create_params
      params.permit(:nickname, :email, :password, :password_confirmation)
    end

    def user_update_params
      params.permit(:nickname, :email)
    end
end
