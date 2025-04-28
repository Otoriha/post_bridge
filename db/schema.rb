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

ActiveRecord::Schema[7.2].define(version: 2025_04_24_023517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.text "access_token"
    t.text "refresh_token"
    t.datetime "expires_at"
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "post_deliveries", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "authentication_id", null: false
    t.string "status", null: false
    t.string "platform_post_id"
    t.string "platform_post_url"
    t.datetime "sent_at"
    t.datetime "scheduled_at"
    t.datetime "processing_started_at"
    t.integer "retry_count", default: 0
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_id"], name: "index_post_deliveries_on_authentication_id"
    t.index ["post_id"], name: "index_post_deliveries_on_post_id"
    t.index ["scheduled_at"], name: "index_post_deliveries_on_scheduled_at"
    t.index ["status"], name: "index_post_deliveries_on_status"
  end

  create_table "post_templates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.json "content"
    t.boolean "is_favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_favorite"], name: "index_post_templates_on_is_favorite"
    t.index ["user_id"], name: "index_post_templates_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_template_id"
    t.string "title"
    t.json "content"
    t.string "status"
    t.boolean "is_favorite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_favorite"], name: "index_posts_on_is_favorite"
    t.index ["post_template_id"], name: "index_posts_on_post_template_id"
    t.index ["status"], name: "index_posts_on_status"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "post_deliveries", "authentications"
  add_foreign_key "post_deliveries", "posts"
  add_foreign_key "post_templates", "users"
  add_foreign_key "posts", "post_templates"
  add_foreign_key "posts", "users"
end
