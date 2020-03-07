# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_06_235518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "givings", force: :cascade do |t|
    t.string "company_name"
    t.string "name"
    t.string "url", null: false
    t.text "blurb", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "twitter"
    t.string "instagram"
    t.string "facebook"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "saved_records", force: :cascade do |t|
    t.integer "user_id"
    t.string "saveable_type"
    t.bigint "saveable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saveable_type", "saveable_id"], name: "index_saved_records_on_saveable_type_and_saveable_id"
    t.index ["user_id"], name: "index_saved_records_on_user_id"
  end

  create_table "spotlights", force: :cascade do |t|
    t.string "company_name"
    t.string "name"
    t.string "url", null: false
    t.text "blurb", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "twitter"
    t.string "instagram"
    t.string "facebook"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "texts", force: :cascade do |t|
    t.string "headline", null: false
    t.string "blurb", null: false
    t.string "url", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.date "published_date"
    t.string "author"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.boolean "admin", default: false, null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "headline", null: false
    t.string "blurb", null: false
    t.string "url", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.date "published_date"
    t.string "author"
  end

end
