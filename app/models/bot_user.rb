class BotUser < ApplicationRecord
  validates :twitch_nickname, uniqueness: { allow_blank: true }
  validates :twitch_id, uniqueness: { allow_blank: true }
  validates :discord_nickname, uniqueness: { allow_blank: true }
  validates :discord_id, uniqueness: { allow_blank: true }
end
