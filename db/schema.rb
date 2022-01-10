# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_08_184121) do

  create_table "access_groups", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "access_group_id", null: false
    t.integer "location_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_items_on_access_group_id"
    t.index ["location_id"], name: "index_items_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent"
    t.integer "access_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_locations_on_access_group_id"
  end

  create_table "user_accesses", force: :cascade do |t|
    t.integer "access_level"
    t.integer "user_id", null: false
    t.integer "access_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_user_accesses_on_access_group_id"
    t.index ["user_id"], name: "index_user_accesses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "activated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "items", "access_groups"
  add_foreign_key "items", "locations"
  add_foreign_key "locations", "access_groups"
  add_foreign_key "user_accesses", "access_groups"
  add_foreign_key "user_accesses", "users"
end
