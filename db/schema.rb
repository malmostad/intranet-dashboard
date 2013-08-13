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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130813114635) do

  create_table "colleagueships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "colleague_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "colleagueships", ["user_id", "colleague_id"], :name => "index_colleagueships_on_user_id_and_colleague_id", :unique => true

  create_table "feed_entries", :force => true do |t|
    t.text     "full",         :limit => 16777215
    t.datetime "published_at"
    t.text     "guid"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_entries", ["feed_id"], :name => "index_feed_entries_on_feed_id"

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.text     "feed_url"
    t.string   "category"
    t.integer  "recent_failures", :default => 0
    t.integer  "total_failures",  :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "fetched_at"
    t.text     "url"
    t.string   "checksum"
    t.integer  "recent_skips",    :default => 0
  end

  create_table "feeds_roles", :id => false, :force => true do |t|
    t.integer "feed_id"
    t.integer "role_id"
  end

  add_index "feeds_roles", ["feed_id", "role_id"], :name => "index_feeds_roles", :unique => true

  create_table "feeds_users", :id => false, :force => true do |t|
    t.integer "feed_id"
    t.integer "user_id"
  end

  add_index "feeds_users", ["feed_id", "user_id"], :name => "index_feeds_user", :unique => true

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "languages", ["name"], :name => "index_languages_on_name"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "homepage_url"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_shortcuts", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "shortcut_id"
  end

  add_index "roles_shortcuts", ["role_id", "shortcut_id"], :name => "index_roles_shortcuts", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shortcuts", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shortcuts_users", :id => false, :force => true do |t|
    t.integer "shortcut_id"
    t.integer "user_id"
  end

  add_index "shortcuts_users", ["shortcut_id", "user_id"], :name => "index_shortcuts_user", :unique => true

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "skills", ["name"], :name => "index_skills_on_name"

  create_table "user_agents", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "remember_me",      :default => false
    t.string   "remember_me_hash"
    t.string   "user_agent_tag"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "user_agents", ["id", "user_id"], :name => "index_user_agents_on_id_and_user_id", :unique => true

  create_table "user_languages", :force => true do |t|
    t.integer  "language_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_languages", ["language_id"], :name => "index_user_languages_on_language_id"
  add_index "user_languages", ["user_id"], :name => "index_user_languages_on_user_id"

  create_table "user_skills", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_skills", ["skill_id"], :name => "index_user_skills_on_skill_id"
  add_index "user_skills", ["user_id"], :name => "index_user_skills_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name",                :default => "Förnamn saknas"
    t.string   "last_name",                 :default => "Efternamn saknas"
    t.string   "email",                     :default => "E-post saknas"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "title"
    t.text     "professional_bio"
    t.string   "status_message"
    t.boolean  "admin",                     :default => false,              :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "displayname"
    t.string   "company"
    t.datetime "last_login"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "status_message_updated_at"
    t.boolean  "early_adopter"
    t.string   "twitter"
    t.string   "skype"
    t.text     "private_bio"
    t.integer  "manager_id"
    t.string   "department"
    t.string   "homepage"
    t.string   "room"
    t.string   "address"
    t.integer  "geo_position_x"
    t.integer  "geo_position_y"
  end

  add_index "users", ["manager_id"], :name => "index_users_on_manager_id"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
