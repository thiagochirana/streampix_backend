class CreateBotUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_users do |t|
      t.string :twitch_id
      t.string :twitch_nickname
      t.string :discord_id
      t.string :discord_nickname
      t.float :wallet_value, default: 0.0

      t.timestamps
    end
  end
end
