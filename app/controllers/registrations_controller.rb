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

    if params[:old_password].present? && !user.authenticate(params[:old_password])
      user.errors.add(:base, "Senha está incorreta")
    end

    if params[:new_password].length < 8
      user.errors.add(:base, "Nova senha não pode ter menos de 8 caracteres")
    end

    if params[:new_password] != params[:confirm_new_password]
      user.errors.add(:base, "Senha e Confirmação de Senha estão diferentes")
    end

    if user.errors && user.errors.any?
      render json: { error: user.errors.full_messages }, status: :unauthorized
      return
    end

    if user.update(password: params[:new_password])
      render json: { message: "Senha atualizada com sucesso" }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  private

    def user_create_params
      params.permit(:nickname, :email, :password, :password_confirmation)
    end

    def user_update_params
      params.permit(:nickname, :email)
    end
end
