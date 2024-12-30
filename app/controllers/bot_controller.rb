class BotController < ApplicationController
  allow_unauthenticated_access

  def register_new_bot_user
    origin = params[:origin]

    if origin == "twitch"
      user = BotUser.new register_twitch_user_params
    elsif origin == "discord"
      user = BotUser.new register_discord_user_params
    else
      render plain: "Origem não informada", status: :bad_request
      return
    end

    if user.save
      render plain: "#{origin == "twitch" ? user.twitch_nickname : user.discord_nickname} foi registrado!"
    else
      render plain: "Não foi possível te registrar! Fale com os adm", status: :bad_request
    end
  end

  private

    def register_twitch_user_params
      params.permit(:twitch_id, :twitch_nickname)
    end

    def register_discord_user_params
      params.permit(:discord_id, :discord_nickname)
    end
end
