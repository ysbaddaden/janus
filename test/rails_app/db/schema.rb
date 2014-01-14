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

ActiveRecord::Schema.define(version: 20130412104138) do

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remote_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
  end

  add_index "remote_tokens", ["token"], name: "index_remote_tokens_on_token", unique: true

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "session_token"
    t.string   "authentication_token"
    t.datetime "authentication_token_created_at"
    t.integer  "sign_in_count",                   default: 0
    t.string   "last_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "current_sign_in_at"
    t.string   "current_sign_in_ip"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["session_token"], name: "index_users_on_session_token", unique: true

end
