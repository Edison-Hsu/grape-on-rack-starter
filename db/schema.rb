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

ActiveRecord::Schema.define(version: 20170209185359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "pgcrypto"

  create_table "chatroom_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "room_id"
    t.string   "role",       limit: 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chatrooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "title",                 limit: 32
    t.string   "leancloud_chatroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid      "user_id",                                                                 null: false
    t.string    "type",           limit: 32,                                               null: false
    t.string    "content",        limit: 1024
    t.geography "lonlat",         limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.tsrange   "available_time"
    t.datetime  "deleted_at"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "title"
    t.string    "cover"
    t.index ["deleted_at", "user_id", "created_at"], name: "index_dives_on_deleted_at_and_user_id_and_created_at", using: :btree
    t.index ["lonlat"], name: "index_dives_on_lonlat", using: :gist
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "from_id",                       null: false
    t.uuid     "to_id",                         null: false
    t.string   "state",        default: "open"
    t.string   "content"
    t.uuid     "dive_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "informations"
    t.datetime "deleted_at"
    t.index ["to_id"], name: "index_notifications_on_to_id", using: :btree
  end

  create_table "sms_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string   "mobile",      limit: 32,               null: false
    t.string   "code",        limit: 16
    t.datetime "expired_at",             precision: 4
    t.datetime "verified_at"
    t.string   "channel"
    t.jsonb    "result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action"
    t.index ["mobile", "created_at"], name: "index_sms_records_on_mobile_and_created_at", using: :btree
  end

  create_table "social_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "identifier",             null: false
    t.string   "type",       limit: 128, null: false
    t.jsonb    "raw"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["deleted_at", "type", "identifier"], name: "index_social_accounts_on_deleted_at_and_type_and_identifier", unique: true, using: :btree
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string   "username",      limit: 255
    t.string   "password_hash", limit: 255
    t.string   "email",         limit: 255
    t.string   "phone",         limit: 64
    t.jsonb    "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["phone"], name: "index_users_on_phone", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "users_concerns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "concern_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_friends", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "friend_id"
    t.datetime "created_at"
    t.index ["user_id", "friend_id"], name: "index_users_friends_on_user_id_and_friend_id", unique: true, using: :btree
  end

  create_table "users_leanclouds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.string   "object_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_users_leanclouds_on_user_id", unique: true, using: :btree
  end

end
