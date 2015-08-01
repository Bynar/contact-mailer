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

ActiveRecord::Schema.define(version: 20150801103106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string   "email"
    t.string   "mandrill_template"
    t.datetime "mandrill_sent_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "leads", ["email"], name: "index_leads_on_email", using: :btree
  add_index "leads", ["first_name", "last_name"], name: "index_leads_on_first_name_last_name", using: :btree

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
