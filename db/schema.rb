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

ActiveRecord::Schema.define(version: 20151203114722) do

  create_table "activities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "activities", ["name"], name: "index_activities_on_name", using: :btree

  create_table "api_apps", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "contact",         limit: 255
    t.string   "app_token",       limit: 255
    t.string   "ip_address",      limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "api_apps", ["app_token"], name: "index_api_apps_on_app_token", using: :btree

  create_table "colleagueships", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "colleague_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "colleagueships", ["user_id", "colleague_id"], name: "index_colleagueships_on_user_id_and_colleague_id", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "feed_entries", force: :cascade do |t|
    t.datetime "published"
    t.text     "guid",           limit: 65535
    t.integer  "feed_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",          limit: 255
    t.string   "image_medium",   limit: 255
    t.string   "image_large",    limit: 255
    t.text     "url",            limit: 65535
    t.text     "title",          limit: 65535
    t.text     "summary",        limit: 65535
    t.integer  "count_comments", limit: 4
  end

  add_index "feed_entries", ["feed_id"], name: "index_feed_entries_on_feed_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "feed_url",        limit: 65535
    t.string   "category",        limit: 255
    t.integer  "recent_failures", limit: 4,     default: 0
    t.integer  "total_failures",  limit: 4,     default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "fetched_at"
    t.text     "url",             limit: 65535
    t.integer  "recent_skips",    limit: 4,     default: 0
    t.string   "etag",            limit: 255
    t.datetime "last_modified"
  end

  create_table "feeds_roles", id: false, force: :cascade do |t|
    t.integer "feed_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "feeds_roles", ["feed_id", "role_id"], name: "index_feeds_roles", unique: true, using: :btree
  add_index "feeds_roles", ["role_id"], name: "index_feeds_roles_on_role_id", using: :btree

  create_table "feeds_users", id: false, force: :cascade do |t|
    t.integer "feed_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "feeds_users", ["feed_id", "user_id"], name: "index_feeds_user", unique: true, using: :btree
  add_index "feeds_users", ["user_id"], name: "index_feeds_users_on_user_id", using: :btree

  create_table "group_contacts", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.string   "email",                           limit: 255
    t.string   "phone",                           limit: 255
    t.string   "cell_phone",                      limit: 255
    t.string   "fax",                             limit: 255
    t.string   "phone_hours",                     limit: 255
    t.string   "homepage",                        limit: 255
    t.string   "address",                         limit: 255
    t.string   "zip_code",                        limit: 255
    t.string   "postal_town",                     limit: 255
    t.string   "visitors_address",                limit: 255
    t.string   "visitors_address_zip_code",       limit: 255
    t.string   "visitors_address_postal_town",    limit: 255
    t.string   "visitors_address_geo_position_x", limit: 255
    t.string   "visitors_address_geo_position_y", limit: 255
    t.string   "visitors_district",               limit: 255
    t.string   "visiting_hours",                  limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.datetime "last_request"
    t.integer  "last_request_by",                 limit: 4
    t.string   "legacy_dn",                       limit: 255
    t.integer  "requests",                        limit: 4,   default: 0
  end

  add_index "group_contacts", ["name"], name: "index_group_contacts_on_name", unique: true, using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "languages", ["name"], name: "index_languages_on_name", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "category",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "homepage_url", limit: 255
  end

  add_index "roles", ["name"], name: "index_roles_on_name", unique: true, using: :btree

  create_table "roles_shortcuts", id: false, force: :cascade do |t|
    t.integer "role_id",     limit: 4
    t.integer "shortcut_id", limit: 4
  end

  add_index "roles_shortcuts", ["role_id", "shortcut_id"], name: "index_roles_shortcuts", unique: true, using: :btree

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users", unique: true, using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "shortcuts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.string   "category",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shortcuts_users", id: false, force: :cascade do |t|
    t.integer "shortcut_id", limit: 4
    t.integer "user_id",     limit: 4
  end

  add_index "shortcuts_users", ["shortcut_id", "user_id"], name: "index_shortcuts_user", unique: true, using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree

  create_table "user_activities", force: :cascade do |t|
    t.integer  "activity_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "user_activities", ["activity_id"], name: "index_user_activities_on_activity_id", using: :btree
  add_index "user_activities", ["user_id"], name: "index_user_activities_on_user_id", using: :btree

  create_table "user_agents", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.boolean  "remember_me",                  default: false
    t.string   "remember_me_hash", limit: 255
    t.string   "user_agent_tag",   limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "user_agents", ["id", "user_id"], name: "index_user_agents_on_id_and_user_id", unique: true, using: :btree

  create_table "user_languages", force: :cascade do |t|
    t.integer  "language_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "user_languages", ["language_id"], name: "index_user_languages_on_language_id", using: :btree
  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id", using: :btree

  create_table "user_skills", force: :cascade do |t|
    t.integer  "skill_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_skills", ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
  add_index "user_skills", ["user_id"], name: "index_user_skills_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",                      limit: 255
    t.string   "first_name",                    limit: 255,   default: "Förnamn saknas"
    t.string   "last_name",                     limit: 255,   default: "Efternamn saknas"
    t.string   "email",                         limit: 255,   default: "E-post saknas"
    t.string   "phone",                         limit: 255
    t.string   "cell_phone",                    limit: 255
    t.string   "title",                         limit: 255
    t.text     "professional_bio",              limit: 65535
    t.string   "status_message",                limit: 191
    t.boolean  "admin",                                       default: false,              null: false
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "displayname",                   limit: 255
    t.string   "company",                       limit: 255
    t.datetime "last_login"
    t.string   "avatar_file_name",              limit: 255
    t.string   "avatar_content_type",           limit: 255
    t.integer  "avatar_file_size",              limit: 4
    t.datetime "avatar_updated_at"
    t.datetime "status_message_updated_at"
    t.boolean  "early_adopter"
    t.string   "twitter",                       limit: 255
    t.string   "skype",                         limit: 255
    t.text     "private_bio",                   limit: 65535
    t.integer  "manager_id",                    limit: 4
    t.string   "department",                    limit: 255
    t.string   "homepage",                      limit: 255
    t.string   "room",                          limit: 255
    t.string   "address",                       limit: 255
    t.integer  "geo_position_x",                limit: 4
    t.integer  "geo_position_y",                limit: 4
    t.string   "cmg_id",                        limit: 255,   default: "0"
    t.boolean  "deactivated",                                 default: false
    t.datetime "deactivated_at"
    t.boolean  "contacts_editor",                             default: false
    t.string   "district",                      limit: 255
    t.string   "post_code",                     limit: 255
    t.string   "postal_town",                   limit: 255
    t.string   "house_identifier",              limit: 255
    t.string   "physical_delivery_office_name", limit: 255
    t.string   "adm_department",                limit: 255
    t.boolean  "combined_feed_stream",                        default: false
    t.string   "linkedin",                      limit: 255
    t.boolean  "changed_shortcuts",                           default: false
    t.boolean  "department_selected",                         default: false
    t.boolean  "working_field_selected",                      default: false
  end

  add_index "users", ["manager_id"], name: "index_users_on_manager_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
