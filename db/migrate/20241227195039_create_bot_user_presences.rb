class CreateBotUserPresences < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_user_presences do |t|
      t.references :bot_user, null: false, foreign_key: true
      t.date :date_presence

      t.timestamps
    end
  end
end
