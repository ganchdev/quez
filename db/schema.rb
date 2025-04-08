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

ActiveRecord::Schema[8.1].define(version: 2025_04_03_171237) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "question_id", null: false
    t.text "text"
    t.boolean "correct", default: false, null: false
    t.string "color"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_streak", default: 0, null: false
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["user_id"], name: "index_game_players_on_user_id"
  end

  create_table "game_questions", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "question_id", null: false
    t.integer "current_phase", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.index ["game_id"], name: "index_game_questions_on_game_id"
    t.index ["question_id"], name: "index_game_questions_on_question_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.integer "host_id", null: false
    t.integer "current_question_id"
    t.string "key", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_question_id"], name: "index_games_on_current_question_id"
    t.index ["host_id"], name: "index_games_on_host_id"
    t.index ["key"], name: "index_games_on_key"
    t.index ["quiz_id"], name: "index_games_on_quiz_id"
  end

  create_table "player_answers", force: :cascade do |t|
    t.integer "game_player_id", null: false
    t.integer "game_question_id", null: false
    t.integer "answer_id", null: false
    t.boolean "correct", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_player_answers_on_answer_id"
    t.index ["game_player_id"], name: "index_player_answers_on_game_player_id"
    t.index ["game_question_id"], name: "index_player_answers_on_game_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "quiz_id", null: false
    t.text "text"
    t.integer "duration", default: 120, null: false
    t.integer "points", default: 1
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "sessions", "users"
end
