# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_13_211902) do
  create_table "donate_configurations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "pix_key", null: false
    t.string "alert_access_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_access_key"], name: "index_donate_configurations_on_alert_access_key", unique: true
    t.index ["user_id"], name: "index_donate_configurations_on_user_id"
  end

  create_table "donates", force: :cascade do |t|
    t.string "nickname", null: false
    t.float "value", null: false
    t.string "message", null: false
    t.text "pix_copia_cola"
    t.text "qrcode"
    t.string "txid"
    t.string "end_to_end_id"
    t.datetime "paid_at"
    t.datetime "expires_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "audio_donate"
    t.string "voice_sellected"
    t.index ["user_id"], name: "index_donates_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "jti", null: false
    t.string "jwt", null: false
    t.string "token_type", null: false
    t.datetime "expires_at", null: false
    t.boolean "revoked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_tokens_on_jti", unique: true
    t.index ["jwt"], name: "index_tokens_on_jwt", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "donate_configurations", "users"
  add_foreign_key "donates", "users"
  add_foreign_key "tokens", "users"
end
