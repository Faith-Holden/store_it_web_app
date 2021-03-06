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

ActiveRecord::Schema.define(version: 2022_02_11_202036) do

  create_table "access_groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "item_locations", force: :cascade do |t|
    t.integer "location_id"
    t.integer "item_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_item_locations_on_item_id"
    t.index ["location_id"], name: "index_item_locations_on_location_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items_accesses", force: :cascade do |t|
    t.integer "access_group_id", null: false
    t.integer "item_id", null: false
    t.integer "num_of_locations", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_items_accesses_on_access_group_id"
    t.index ["item_id"], name: "index_items_accesses_on_item_id"
  end

  create_table "location_accesses", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "access_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_location_accesses_on_access_group_id"
    t.index ["location_id"], name: "index_location_accesses_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "access_group_id", null: false
    t.boolean "group_admin"
    t.boolean "can_see_group"
    t.boolean "can_see_items"
    t.boolean "can_see_locations"
    t.boolean "can_crud_group"
    t.boolean "can_crud_user_access"
    t.boolean "can_crud_subgroups"
    t.boolean "can_crud_item_access"
    t.boolean "can_crud_location_access"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_group_id"], name: "index_user_accesses_on_access_group_id"
    t.index ["user_id"], name: "index_user_accesses_on_user_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "is_sys_admin"
    t.boolean "can_crud_items"
    t.boolean "can_crud_access_group_no_parent"
    t.boolean "can_crud_locations_with_parent"
    t.boolean "can_crud_locations_no_parent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "item_locations", "items"
  add_foreign_key "item_locations", "locations"
  add_foreign_key "items_accesses", "access_groups"
  add_foreign_key "items_accesses", "items"
  add_foreign_key "user_accesses", "access_groups"
  add_foreign_key "user_accesses", "users"
end
