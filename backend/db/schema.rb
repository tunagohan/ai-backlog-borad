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

ActiveRecord::Schema[7.2].define(version: 2026_02_18_000008) do
  create_table "assets", force: :cascade do |t|
    t.integer "space_id", null: false
    t.string "name", null: false
    t.string "category"
    t.string "serial_number"
    t.date "installed_on"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_assets_on_space_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inspection_jobs", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "template_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "scheduled_for", null: false
    t.string "status", default: "scheduled", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "status", "scheduled_for"], name: "idx_on_company_id_status_scheduled_for_f227a4352d"
    t.index ["company_id"], name: "index_inspection_jobs_on_company_id"
    t.index ["template_id"], name: "index_inspection_jobs_on_template_id"
  end

  create_table "inspection_template_items", force: :cascade do |t|
    t.integer "section_id", null: false
    t.string "name", null: false
    t.string "result_type", null: false
    t.string "unit"
    t.integer "sort_order", default: 0, null: false
    t.boolean "required", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_inspection_template_items_on_section_id"
  end

  create_table "inspection_template_sections", force: :cascade do |t|
    t.integer "template_id", null: false
    t.string "name", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_inspection_template_sections_on_template_id"
  end

  create_table "inspection_templates", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "name", null: false
    t.integer "version", default: 1, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "name", "version"], name: "index_inspection_templates_on_company_id_and_name_and_version", unique: true
    t.index ["company_id"], name: "index_inspection_templates_on_company_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "name", null: false
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_properties_on_company_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.integer "store_id", null: false
    t.string "name", null: false
    t.string "floor_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_spaces_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "property_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_stores_on_property_id"
  end

  add_foreign_key "assets", "spaces"
  add_foreign_key "inspection_jobs", "companies"
  add_foreign_key "inspection_jobs", "inspection_templates", column: "template_id"
  add_foreign_key "inspection_template_items", "inspection_template_sections", column: "section_id"
  add_foreign_key "inspection_template_sections", "inspection_templates", column: "template_id"
  add_foreign_key "inspection_templates", "companies"
  add_foreign_key "properties", "companies"
  add_foreign_key "spaces", "stores"
  add_foreign_key "stores", "properties"
end
