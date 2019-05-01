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

ActiveRecord::Schema.define(version: 2019_05_01_170911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "descriptions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_descriptions_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "provider_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.date "duedate"
    t.date "paymentdate"
    t.integer "amount_cents"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["provider_id"], name: "index_expenses_on_provider_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_providers_on_user_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "description_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "amount_cents"
    t.index ["description_id"], name: "index_receipts_on_description_id"
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "kind"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "descriptions", "users"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "providers"
  add_foreign_key "expenses", "users"
  add_foreign_key "providers", "users"
  add_foreign_key "receipts", "descriptions"
  add_foreign_key "receipts", "users"
end
