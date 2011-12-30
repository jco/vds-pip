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

ActiveRecord::Schema.define(:version => 20111230220451) do

  create_table "dependencies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upstream_item_id"
    t.string   "upstream_item_type"
    t.integer  "downstream_item_id"
    t.string   "downstream_item_type"
  end

  create_table "documents", :force => true do |t|
    t.integer  "folder_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x",           :default => 0, :null => false
    t.integer  "y",           :default => 0, :null => false
    t.integer  "task_id"
    t.string   "status"
    t.integer  "project_id"
  end

  create_table "factors", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_folder_id"
    t.integer  "x",                :default => 0, :null => false
    t.integer  "y",                :default => 0, :null => false
    t.integer  "task_id"
    t.integer  "project_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "project_manager"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "parent_task_id"
    t.integer  "stage_id"
    t.integer  "factor_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  create_table "versions", :force => true do |t|
    t.integer  "document_id"
    t.string   "external_url"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
