class CreateDonates < ActiveRecord::Migration[8.0]
  def change
    create_table :donates do |t|
      t.string :nickname, null: false
      t.float :value, null: false
      t.string :message, null: false
      t.text :pix_copia_cola
      t.text :qrcode
      t.datetime :expires_at
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
