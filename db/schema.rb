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

ActiveRecord::Schema[8.0].define(version: 2025_07_23_013556) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "visitor_session_id", null: false
    t.text "query", null: false
    t.datetime "typed_at", null: false
    t.string "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visitor_session_id", "typed_at"], name: "index_search_events_on_visitor_session_id_and_typed_at"
    t.index ["visitor_session_id"], name: "index_search_events_on_visitor_session_id"
  end

  create_table "search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "visitor_session_id", null: false
    t.string "term", null: false
    t.integer "occurences", default: 1, null: false
    t.datetime "first_seen_at", null: false
    t.datetime "last_seen_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term"], name: "index_search_terms_on_term"
    t.index ["visitor_session_id"], name: "index_search_terms_on_visitor_session_id"
  end

  create_table "visitor_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.inet "ip_address", null: false
    t.text "user_agent"
    t.string "session_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_token"], name: "index_visitor_sessions_on_session_token", unique: true
  end

  add_foreign_key "search_events", "visitor_sessions"
  add_foreign_key "search_terms", "visitor_sessions"
end
