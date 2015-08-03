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

ActiveRecord::Schema.define(version: 20150731021622) do

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

  add_index "authentications", ["user_id", "provider"], name: "index_authentications_on_user_id_and_provider", using: :btree

  create_table "columns", force: true do |t|
    t.string   "name"
    t.text     "introduce"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover"
    t.string   "icon"
    t.integer  "posts_count"
    t.string   "slug"
    t.integer  "order_num"
    t.text     "extra"
    t.boolean  "hidden_cover", default: false
  end

  create_table "columns_info_flows", force: true do |t|
    t.integer  "info_flow_id"
    t.integer  "column_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "columns_sites", force: true do |t|
    t.integer  "column_id"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_num",  default: 0
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
    t.string   "ancestry"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "url_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["url_code"], name: "index_favorites_on_url_code", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "fragment_templates", force: true do |t|
    t.string   "key"
    t.string   "name"
    t.text     "content"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fragment_templates", ["key"], name: "index_fragment_templates_on_key", unique: true, using: :btree

  create_table "head_lines", force: true do |t|
    t.string   "url"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "post_type"
    t.string   "image"
    t.integer  "user_id"
    t.integer  "url_code"
    t.string   "state"
    t.string   "section"
    t.boolean  "hidden_title"
    t.text     "extra"
    t.text     "display_position"
    t.text     "summary"
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
    t.string   "news_summaries",           limit: 8000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "cover"
    t.boolean  "is_top",                                default: false
    t.datetime "toped_at"
    t.integer  "views_count",                           default: 0
    t.integer  "column_id"
    t.text     "extra"
  end

  add_index "newsflashes", ["created_at"], name: "index_newsflashes_on_created_at", using: :btree

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
    t.integer  "views_count",       default: 0
    t.string   "catch_title"
    t.datetime "published_at"
    t.string   "key"
    t.text     "remark"
    t.text     "extra"
    t.string   "source_type"
    t.integer  "favorites_count"
    t.string   "company_keywords",  default: [], array: true
    t.integer  "favoriter_sso_ids", default: [], array: true
    t.string   "column_name"
  end

  add_index "posts", ["column_id"], name: "index_posts_on_column_id", using: :btree
  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["key"], name: "index_posts_on_key", using: :btree
  add_index "posts", ["published_at"], name: "index_posts_on_published_at", using: :btree
  add_index "posts", ["url_code"], name: "index_posts_on_url_code", unique: true, using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "related_links", force: true do |t|
    t.string   "url"
    t.string   "link_type"
    t.string   "title"
    t.string   "image"
    t.text     "description"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "user_id"
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "domain"
    t.integer  "info_flow_id"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "columns_id_and_name", default: [], array: true
    t.string   "slug"
  end

  add_index "sites", ["slug"], name: "index_sites_on_slug", using: :hash

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "sites", ["slug"], name: "index_sites_on_slug", using: :hash

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
    t.datetime "muted_at"
    t.integer  "favorites_count"
    t.text     "extra"
    t.string   "domain"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["domain"], name: "index_users_on_domain", using: :hash
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["sso_id"], name: "index_users_on_sso_id", using: :btree

end
