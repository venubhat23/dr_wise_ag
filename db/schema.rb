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

ActiveRecord::Schema[8.0].define(version: 2025_11_16_115323) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agency_brokers", force: :cascade do |t|
    t.string "broker_name"
    t.string "broker_code"
    t.string "agency_code"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "redirect_link"
    t.date "display_start_date"
    t.date "display_end_date"
    t.string "display_location"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "customer_type"
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "email"
    t.string "mobile"
    t.string "address"
    t.string "state"
    t.string "city"
    t.date "birth_date"
    t.integer "age"
    t.string "gender"
    t.string "height"
    t.string "weight"
    t.string "education"
    t.string "marital_status"
    t.string "occupation"
    t.string "job_name"
    t.string "type_of_duty"
    t.decimal "annual_income"
    t.string "pan_number"
    t.string "gst_number"
    t.string "birth_place"
    t.text "additional_info"
    t.boolean "status"
    t.string "added_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_members", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name"
    t.date "birth_date"
    t.integer "age"
    t.string "height"
    t.string "weight"
    t.string "gender"
    t.string "relationship"
    t.string "pan_number"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_family_members_on_customer_id"
  end

  create_table "health_insurances", force: :cascade do |t|
    t.bigint "policy_id", null: false
    t.string "insurance_type"
    t.string "claim_process"
    t.decimal "main_agent_commission_percent"
    t.decimal "main_agent_commission_amount"
    t.decimal "main_agent_tds_percent"
    t.decimal "main_agent_tds_amount"
    t.string "reference_by_name"
    t.string "broker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_health_insurances_on_policy_id"
  end

  create_table "insurance_companies", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.string "contact_number"
    t.string "email"
    t.string "referred_by"
    t.string "product_interest"
    t.string "current_stage"
    t.date "created_date"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "life_insurances", force: :cascade do |t|
    t.bigint "policy_id", null: false
    t.string "insured_name"
    t.string "nominee_name"
    t.string "nominee_relationship"
    t.integer "nominee_age"
    t.integer "premium_payment_term"
    t.decimal "first_year_gst"
    t.decimal "second_year_gst"
    t.decimal "third_year_gst"
    t.decimal "main_agent_commission_percent_first"
    t.decimal "main_agent_commission_percent_renewal"
    t.decimal "main_agent_commission_amount"
    t.decimal "main_agent_tds_percent"
    t.decimal "main_agent_tds_amount"
    t.string "reference_by_name"
    t.string "broker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_life_insurances_on_policy_id"
  end

  create_table "motor_insurances", force: :cascade do |t|
    t.bigint "policy_id", null: false
    t.string "vehicle_type"
    t.string "class_of_vehicle"
    t.string "registration_number"
    t.date "registration_date"
    t.string "engine_number"
    t.string "chassis_number"
    t.integer "mfy"
    t.string "make"
    t.string "model"
    t.string "variant"
    t.integer "seating_capacity"
    t.decimal "discount_loading_percent"
    t.string "previous_policy_number"
    t.string "ncb"
    t.string "legal_liability"
    t.string "electrical_accessories"
    t.string "non_electrical_accessories"
    t.boolean "zero_depreciation"
    t.boolean "roadside_assistance"
    t.boolean "engine_protector"
    t.boolean "key_replacement"
    t.boolean "return_to_invoice"
    t.boolean "consumable_cover"
    t.boolean "personal_accident_cover"
    t.string "financier"
    t.decimal "vehicle_idv"
    t.decimal "cng_idv"
    t.decimal "total_idv"
    t.decimal "tp_premium"
    t.decimal "payout_od"
    t.decimal "payout_tp"
    t.decimal "payout_net"
    t.decimal "main_agent_commission_percent"
    t.decimal "main_agent_commission_amount"
    t.decimal "main_agent_tds_percent"
    t.decimal "main_agent_tds_amount"
    t.string "broker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_motor_insurances_on_policy_id"
  end

  create_table "other_insurances", force: :cascade do |t|
    t.bigint "policy_id", null: false
    t.string "other_policy_type"
    t.decimal "main_agent_commission_percent"
    t.decimal "main_agent_commission_amount"
    t.decimal "main_agent_tds_percent"
    t.decimal "main_agent_tds_amount"
    t.string "reference_by_name"
    t.string "broker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_other_insurances_on_policy_id"
  end

  create_table "policies", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "user_id", null: false
    t.bigint "insurance_company_id", null: false
    t.bigint "agency_broker_id", null: false
    t.string "policy_number"
    t.string "policy_type"
    t.string "insurance_type"
    t.string "plan_name"
    t.string "payment_mode"
    t.date "policy_booking_date"
    t.date "policy_start_date"
    t.date "policy_end_date"
    t.integer "policy_term_years"
    t.date "risk_start_date"
    t.decimal "sum_insured"
    t.decimal "net_premium"
    t.decimal "gst_percentage"
    t.decimal "total_premium"
    t.decimal "bonus"
    t.decimal "fund"
    t.text "note"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_broker_id"], name: "index_policies_on_agency_broker_id"
    t.index ["customer_id"], name: "index_policies_on_customer_id"
    t.index ["insurance_company_id"], name: "index_policies_on_insurance_company_id"
    t.index ["user_id"], name: "index_policies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mobile"
    t.string "pan_number"
    t.string "gst_number"
    t.date "date_of_birth"
    t.string "gender"
    t.string "height"
    t.string "weight"
    t.string "education"
    t.string "marital_status"
    t.string "occupation"
    t.string "job_name"
    t.string "type_of_duty"
    t.decimal "annual_income"
    t.string "birth_place"
    t.string "address"
    t.string "state"
    t.string "city"
    t.string "user_type"
    t.string "role"
    t.boolean "status"
    t.text "additional_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "family_members", "customers"
  add_foreign_key "health_insurances", "policies"
  add_foreign_key "life_insurances", "policies"
  add_foreign_key "motor_insurances", "policies"
  add_foreign_key "other_insurances", "policies"
  add_foreign_key "policies", "agency_brokers"
  add_foreign_key "policies", "customers"
  add_foreign_key "policies", "insurance_companies"
  add_foreign_key "policies", "users"
end
