# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141207115640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorite_destinations", force: true do |t|
    t.integer  "user_id"
    t.string   "city"
    t.string   "stop_sid"
    t.string   "destination"
    t.boolean  "favorite"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorite_destinations", ["city"], name: "index_favorite_destinations_on_city", using: :btree
  add_index "favorite_destinations", ["destination"], name: "index_favorite_destinations_on_destination", using: :btree
  add_index "favorite_destinations", ["favorite"], name: "index_favorite_destinations_on_favorite", using: :btree
  add_index "favorite_destinations", ["stop_sid"], name: "index_favorite_destinations_on_stop_sid", using: :btree
  add_index "favorite_destinations", ["user_id"], name: "index_favorite_destinations_on_user_id", using: :btree

  create_table "favorite_stops", force: true do |t|
    t.integer  "user_id",                    null: false
    t.string   "city",                       null: false
    t.string   "stop_sid",                   null: false
    t.boolean  "favorite",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "favorite_stops", ["city"], name: "index_favorite_stops_on_city", using: :btree
  add_index "favorite_stops", ["favorite"], name: "index_favorite_stops_on_favorite", using: :btree
  add_index "favorite_stops", ["stop_sid"], name: "index_favorite_stops_on_stop_sid", using: :btree
  add_index "favorite_stops", ["user_id"], name: "index_favorite_stops_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "stop_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "stop_id",       null: false
    t.integer  "day_of_week",   null: false
    t.integer  "minute_of_day", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "stop_requests", ["user_id"], name: "index_stop_requests_on_user_id", using: :btree

  create_table "transit_stops", force: true do |t|
    t.string   "city"
    t.string   "stop_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "indicator"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "trip_requests", force: true do |t|
    t.integer  "user_id"
    t.string   "line_name",     null: false
    t.integer  "day_of_week",   null: false
    t.integer  "minute_of_day", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "trip_requests", ["user_id"], name: "index_trip_requests_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                default: "", null: false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "photo_url"
    t.string   "big_photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
