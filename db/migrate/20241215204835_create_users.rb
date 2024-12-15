class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email,            null: false
      t.string :password_digest,  null: false

      t.timestamps
    end
    add_index :users, :nickname,  unique: true
    add_index :users, :email,     unique: true
  end
end
