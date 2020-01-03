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

ActiveRecord::Schema.define(version: 20191130223901) do

  create_table "families", force: :cascade do |t|
    t.string "name"
  end

  create_table "family_users", force: :cascade do |t|
    t.integer "family_id"
    t.integer "user_id"
    t.boolean "is_family_admin", default: false
  end

  add_index "family_users", ["family_id"], name: "index_family_users_on_family_id"
  add_index "family_users", ["user_id"], name: "index_family_users_on_user_id"

  create_table "gifts", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.string  "url"
    t.float   "price"
    t.integer "user_id"
    t.integer "purchaser_id"
  end

  add_index "gifts", ["user_id"], name: "index_gifts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "username"
    t.string  "password_digest"
    t.boolean "is_site_admin",   default: false
  end

end
