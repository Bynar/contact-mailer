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

ActiveRecord::Schema.define(version: 20151116200801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "website",    null: false
    t.string   "form"
    t.string   "context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["email", "full_name"], name: "index_contacts_on_email_full_name", using: :btree
  add_index "contacts", ["email"], name: "index_contacts_on_email", using: :btree
  add_index "contacts", ["full_name"], name: "index_contacts_on_full_name", using: :btree
  add_index "contacts", ["website"], name: "index_contacts_on_website", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mandrill_template"
    t.datetime "mandrill_sent_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "website"
    t.string   "email"
    t.string   "raw_email"
    t.string   "source"
  end

  add_index "leads", ["first_name", "last_name"], name: "index_leads_on_first_name_last_name", using: :btree
  add_index "leads", ["website"], name: "index_leads_on_website", using: :btree

  create_table "twitterers", force: :cascade do |t|
    t.integer  "twitter_id",      limit: 8
    t.string   "username"
    t.string   "fullname"
    t.datetime "last_tweet_date"
    t.text     "description"
    t.string   "location"
    t.string   "twitter_url"
    t.integer  "followers_count"
    t.string   "real_url"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "crawled_at"
  end

  add_index "twitterers", ["fullname"], name: "index_twitterers_on_fullname", using: :btree
  add_index "twitterers", ["real_url"], name: "index_twitterers_on_real_url", using: :btree

end
