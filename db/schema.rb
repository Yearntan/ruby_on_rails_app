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

ActiveRecord::Schema[7.0].define(version: 2024_05_17_110116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answer_alerts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "answer_id", null: false
    t.text "commit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["answer_id"], name: "index_answer_alerts_on_answer_id"
  end

  create_table "answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "question_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["question_id", "user_id"], name: "index_answers_on_question_id_and_user_id", unique: true
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "answers_bubbles", force: :cascade do |t|
    t.uuid "answer_id", null: false
    t.uuid "bubble_id", null: false
    t.index ["answer_id", "bubble_id"], name: "index_answers_bubbles_on_answer_id_and_bubble_id", unique: true
  end

  create_table "bubble_invites", force: :cascade do |t|
    t.bigint "young_person_id", null: false
    t.bigint "bubble_member_id"
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["bubble_member_id"], name: "index_bubble_invites_on_bubble_member_id"
    t.index ["young_person_id"], name: "index_bubble_invites_on_young_person_id"
  end

  create_table "bubble_members", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.index ["user_id"], name: "index_bubble_members_on_user_id"
  end

  create_table "bubble_members_bubbles", force: :cascade do |t|
    t.uuid "bubble_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.index ["bubble_id"], name: "index_bubble_members_bubbles_on_bubble_id"
    t.index ["member_id"], name: "index_bubble_members_bubbles_on_member_id"
  end

  create_table "bubbles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.bigint "holder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["holder_id"], name: "index_bubbles_on_holder_id"
  end

  create_table "change_request", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "question_id", null: false
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.index ["question_id"], name: "index_change_request_on_question_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "emotional_supports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: false
    t.index ["user_id"], name: "index_emotional_supports_on_user_id"
  end

  create_table "future_message_alerts", force: :cascade do |t|
    t.uuid "future_message_id", null: false
    t.boolean "active", default: true
    t.text "commit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["future_message_id"], name: "index_future_message_alerts_on_future_message_id"
  end

  create_table "future_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "published_at"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "publishable", default: false
    t.index ["user_id"], name: "index_future_messages_on_user_id"
  end

  create_table "future_messages_bubbles", force: :cascade do |t|
    t.uuid "future_message_id", null: false
    t.uuid "bubble_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bubble_id"], name: "index_future_messages_bubbles_on_bubble_id"
    t.index ["future_message_id", "bubble_id"], name: "index_fmsg_bubbles_on_fmsg_id_and_bubble_id", unique: true
    t.index ["future_message_id"], name: "index_future_messages_bubbles_on_future_message_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "code"
    t.string "email"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expiration_date"
    t.string "role"
    t.text "message"
    t.uuid "user_id"
    t.string "token"
  end

  create_table "ques_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sensitivity"
    t.bigint "ques_category_id"
    t.boolean "change", default: false
    t.boolean "active", default: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "supporters", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_supporters_on_user_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "pronouns"
    t.integer "status"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "token"
    t.boolean "bypass_invite_validation"
    t.index ["id"], name: "index_users_on_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "young_people", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "passed_away", default: false
    t.index ["user_id"], name: "index_young_people_on_user_id", unique: true
  end

  create_table "young_person_managements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supporter_id", null: false
    t.uuid "young_person_id", null: false
    t.text "commit"
    t.integer "active", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_yp_managements_on_id"
    t.index ["supporter_id"], name: "index_yp_managements_on_supporter_id"
    t.index ["young_person_id"], name: "index_yp_managements_on_yp_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answer_alerts", "answers", on_delete: :cascade
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "young_people", column: "user_id", primary_key: "user_id"
  add_foreign_key "answers_bubbles", "answers"
  add_foreign_key "answers_bubbles", "bubbles"
  add_foreign_key "bubble_invites", "bubble_members"
  add_foreign_key "bubble_invites", "young_people"
  add_foreign_key "bubble_members", "users"
  add_foreign_key "bubble_members_bubbles", "bubble_invites", column: "member_id"
  add_foreign_key "bubble_members_bubbles", "bubbles"
  add_foreign_key "change_request", "questions"
  add_foreign_key "emotional_supports", "young_people", column: "user_id", primary_key: "user_id"
  add_foreign_key "future_message_alerts", "future_messages"
  add_foreign_key "future_messages", "young_people", column: "user_id", primary_key: "user_id"
  add_foreign_key "future_messages_bubbles", "bubbles"
  add_foreign_key "future_messages_bubbles", "future_messages"
  add_foreign_key "questions", "ques_categories"
  add_foreign_key "supporters", "users"
  add_foreign_key "young_people", "users"
  add_foreign_key "young_person_managements", "supporters", primary_key: "user_id"
  add_foreign_key "young_person_managements", "young_people", primary_key: "user_id"
end
