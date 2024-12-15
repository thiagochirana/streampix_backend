class CreateTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :jti, null: false
      t.string :token_type, null: false
      t.datetime :expires_at, null: false
      t.boolean :revoked, default: false

      t.timestamps
    end

    add_index :tokens, :jti, unique: true
  end
end
