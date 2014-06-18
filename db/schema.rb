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

ActiveRecord::Schema.define(:version => 20140618155101) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "activities", ["name"], :name => "index_activities_on_name"

  create_table "api_apps", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "app_token"
    t.string   "ip_address"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "api_apps", ["app_token"], :name => "index_api_apps_on_app_token"

  create_table "colleagueships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "colleague_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "colleagueships", ["user_id", "colleague_id"], :name => "index_colleagueships_on_user_id_and_colleague_id", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "feed_entries", :force => true do |t|
    t.datetime "published"
    t.text     "guid"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "image_medium"
    t.string   "image_large"
    t.string   "url"
    t.string   "title"
    t.text     "summary"
    t.integer  "count_comments"
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
    t.integer  "recent_skips",    :default => 0
    t.string   "etag"
    t.datetime "last_modified"
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

  create_table "group_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "fax"
    t.string   "phone_hours"
    t.string   "homepage"
    t.string   "address"
    t.string   "zip_code"
    t.string   "postal_town"
    t.string   "visitors_address"
    t.string   "visitors_address_zip_code"
    t.string   "visitors_address_postal_town"
    t.string   "visitors_address_geo_position_x"
    t.string   "visitors_address_geo_position_y"
    t.string   "visitors_district"
    t.string   "visiting_hours"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "last_request"
    t.integer  "last_request_by"
    t.string   "legacy_dn"
  end

  add_index "group_contacts", ["name"], :name => "index_group_contacts_on_name", :unique => true

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

  create_table "user_activities", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "user_activities", ["activity_id"], :name => "index_user_activities_on_activity_id"
  add_index "user_activities", ["user_id"], :name => "index_user_activities_on_user_id"

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
    t.string   "first_name",                    :default => "Förnamn saknas"
    t.string   "last_name",                     :default => "Efternamn saknas"
    t.string   "email",                         :default => "E-post saknas"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "title"
    t.text     "professional_bio"
    t.string   "status_message"
    t.boolean  "admin",                         :default => false,              :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
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
    t.string   "cmg_id",                        :default => "0"
    t.boolean  "deactivated",                   :default => false
    t.datetime "deactivated_at"
    t.boolean  "contacts_editor",               :default => false
    t.string   "district"
    t.string   "post_code"
    t.string   "postal_town"
    t.string   "house_identifier"
    t.string   "physical_delivery_office_name"
    t.string   "adm_department"
  end

  add_index "users", ["manager_id"], :name => "index_users_on_manager_id"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
