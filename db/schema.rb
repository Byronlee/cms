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

ActiveRecord::Schema.define(version: 20150319063958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: true do |t|
    t.integer  "position"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ads_info_flows", force: true do |t|
    t.integer  "info_flow_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.string   "uid"
    t.string   "provider"
    t.text     "raw"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "columns", force: true do |t|
    t.string   "name"
    t.text     "introduce"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover"
    t.string   "icon"
    t.integer  "posts_count"
    t.string   "slug"
    t.string   "order_num",   default: "0"
  end

  create_table "columns_info_flows", force: true do |t|
    t.integer  "info_flow_id"
    t.integer  "column_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_excellent"
    t.boolean  "is_long"
    t.string   "state"
    t.string   "email"
  end

  create_table "head_lines", force: true do |t|
    t.string   "url"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "post_type"
    t.string   "image"
    t.integer  "user_id"
  end

  create_table "info_flows", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsflash_topic_colors", force: true do |t|
    t.string   "site_name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsflashes", force: true do |t|
    t.text     "original_input"
    t.string   "hash_title"
    t.text     "description_text"
    t.string   "news_url"
    t.integer  "newsflash_topic_color_id"
    t.string   "news_summaries",           default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.string   "title_link"
    t.boolean  "must_read"
    t.string   "slug"
    t.string   "state"
    t.string   "draft_key"
    t.integer  "column_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cover"
    t.string   "source"
    t.integer  "comments_count"
    t.text     "md_content"
    t.integer  "url_code"
    t.integer  "views_count",    default: 0
    t.text     "catch_title"
    t.datetime "published_at"
    t.string   "key"
    t.text     "remark"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "encrypted_password",                  default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "authentication_token"
    t.string   "name"
    t.text     "bio"
    t.datetime "krypton_passport_invitation_sent_at"
    t.text     "tagline"
    t.string   "avatar_url"
    t.integer  "sso_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
