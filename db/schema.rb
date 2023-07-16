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

ActiveRecord::Schema[7.0].define(version: 2023_07_16_164602) do
  create_table "game_sessions", force: :cascade do |t|
    t.string "game_name"
    t.text "questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "answers"
    t.integer "winner_id"
    t.index ["winner_id"], name: "index_game_sessions_on_winner_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "game_session_id", null: false
    t.index ["game_session_id"], name: "index_players_on_game_session_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
  end

  add_foreign_key "game_sessions", "players", column: "winner_id"
  add_foreign_key "players", "game_sessions"
  add_foreign_key "players", "users"
end
