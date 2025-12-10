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

ActiveRecord::Schema[8.0].define(version: 2025_12_10_010533) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "agency_codes", force: :cascade do |t|
    t.string "insurance_type"
    t.string "company_name"
    t.string "agent_name"
    t.string "code"
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

  create_table "brokers", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brokers_on_name"
    t.index ["status"], name: "index_brokers_on_status"
  end

  create_table "client_requests", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number", null: false
    t.text "description", null: false
    t.string "status", default: "pending"
    t.string "priority", default: "medium"
    t.datetime "submitted_at", null: false
    t.text "admin_response"
    t.datetime "resolved_at"
    t.bigint "resolved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_client_requests_on_email"
    t.index ["resolved_by_id"], name: "index_client_requests_on_resolved_by_id"
    t.index ["status"], name: "index_client_requests_on_status"
    t.index ["submitted_at"], name: "index_client_requests_on_submitted_at"
  end

  create_table "corporate_members", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "company_name"
    t.string "mobile"
    t.string "email"
    t.string "state"
    t.string "city"
    t.text "address"
    t.decimal "annual_income"
    t.string "pan_no"
    t.string "gst_no"
    t.text "additional_information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_corporate_members_on_customer_id"
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
    t.string "nominee_name"
    t.string "nominee_relation"
    t.date "nominee_date_of_birth"
    t.string "pincode"
    t.string "sub_agent", default: "Self"
    t.string "middle_name"
    t.string "height_feet"
    t.decimal "weight_kg", precision: 5, scale: 2
    t.string "business_job"
    t.string "business_name"
    t.text "additional_information"
    t.string "pan_no"
    t.string "gst_no"
  end

  create_table "documents", force: :cascade do |t|
    t.string "document_type"
    t.string "documentable_type", null: false
    t.bigint "documentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable"
  end

  create_table "family_members", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "first_name"
    t.date "birth_date"
    t.integer "age"
    t.string "height"
    t.string "weight"
    t.string "gender"
    t.string "relationship"
    t.string "pan_no"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "middle_name"
    t.string "last_name"
    t.string "height_feet"
    t.decimal "weight_kg", precision: 5, scale: 2
    t.text "additional_information"
    t.index ["customer_id"], name: "index_family_members_on_customer_id"
  end

  create_table "health_insurance_members", force: :cascade do |t|
    t.bigint "health_insurance_id", null: false
    t.string "member_name"
    t.integer "age"
    t.string "relationship"
    t.decimal "sum_insured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_insurance_id"], name: "index_health_insurance_members_on_health_insurance_id"
  end

  create_table "health_insurances", force: :cascade do |t|
    t.bigint "policy_id"
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
    t.bigint "customer_id"
    t.bigint "sub_agent_id"
    t.bigint "agency_code_id"
    t.bigint "broker_id"
    t.string "policy_holder"
    t.string "insurance_company_name"
    t.string "plan_name"
    t.string "policy_number"
    t.date "policy_booking_date"
    t.date "policy_start_date"
    t.date "policy_end_date"
    t.integer "policy_term"
    t.string "payment_mode"
    t.decimal "sum_insured"
    t.decimal "net_premium"
    t.decimal "gst_percentage"
    t.decimal "total_premium"
    t.decimal "main_agent_commission_percentage"
    t.decimal "commission_amount"
    t.decimal "tds_percentage"
    t.decimal "tds_amount"
    t.decimal "after_tds_value"
    t.string "policy_type"
    t.date "installment_autopay_start_date"
    t.date "installment_autopay_end_date"
    t.text "notification_dates"
    t.boolean "is_customer_added", default: false
    t.boolean "is_agent_added", default: false
    t.boolean "is_admin_added", default: false
    t.index ["agency_code_id"], name: "index_health_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_health_insurances_on_broker_id"
    t.index ["customer_id"], name: "index_health_insurances_on_customer_id"
    t.index ["policy_id"], name: "index_health_insurances_on_policy_id"
    t.index ["sub_agent_id"], name: "index_health_insurances_on_sub_agent_id"
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
    t.bigint "customer_id", null: false
    t.bigint "sub_agent_id"
    t.string "policy_holder", null: false
    t.string "insured_name"
    t.string "insurance_company_name", null: false
    t.bigint "agency_code_id"
    t.bigint "broker_id"
    t.string "policy_type", null: false
    t.string "payment_mode", null: false
    t.string "policy_number", null: false
    t.date "policy_booking_date"
    t.date "policy_start_date", null: false
    t.date "policy_end_date", null: false
    t.date "risk_start_date"
    t.integer "policy_term", null: false
    t.integer "premium_payment_term", null: false
    t.string "plan_name"
    t.decimal "sum_insured", precision: 15, scale: 2, null: false
    t.decimal "net_premium", precision: 15, scale: 2, null: false
    t.decimal "first_year_gst_percentage", precision: 5, scale: 2, default: "18.0"
    t.decimal "second_year_gst_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "third_year_gst_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "total_premium", precision: 15, scale: 2, null: false
    t.decimal "term_rider_amount", precision: 15, scale: 2, default: "0.0"
    t.text "term_rider_note"
    t.decimal "critical_illness_rider_amount", precision: 15, scale: 2, default: "0.0"
    t.text "critical_illness_rider_note"
    t.decimal "accident_rider_amount", precision: 15, scale: 2, default: "0.0"
    t.text "accident_rider_note"
    t.decimal "pwb_rider_amount", precision: 15, scale: 2, default: "0.0"
    t.text "pwb_rider_note"
    t.decimal "other_rider_amount", precision: 15, scale: 2, default: "0.0"
    t.text "other_rider_note"
    t.string "nominee_name"
    t.string "nominee_relationship"
    t.integer "nominee_age"
    t.string "bank_name"
    t.string "account_type"
    t.string "account_number"
    t.string "ifsc_code"
    t.string "account_holder_name"
    t.string "reference_by_name"
    t.string "broker_name"
    t.decimal "bonus", precision: 15, scale: 2, default: "0.0"
    t.decimal "fund", precision: 15, scale: 2, default: "0.0"
    t.text "extra_note"
    t.decimal "main_agent_commission_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "tds_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.date "installment_autopay_start_date"
    t.date "installment_autopay_end_date"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notification_dates"
    t.boolean "is_customer_added", default: false
    t.boolean "is_agent_added", default: false
    t.boolean "is_admin_added", default: false
    t.index ["agency_code_id"], name: "index_life_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_life_insurances_on_broker_id"
    t.index ["customer_id"], name: "index_life_insurances_on_customer_id"
    t.index ["insurance_company_name"], name: "index_life_insurances_on_insurance_company_name"
    t.index ["policy_end_date"], name: "index_life_insurances_on_policy_end_date"
    t.index ["policy_number"], name: "index_life_insurances_on_policy_number", unique: true
    t.index ["policy_start_date", "policy_end_date"], name: "index_life_insurances_on_policy_start_date_and_policy_end_date"
    t.index ["policy_start_date"], name: "index_life_insurances_on_policy_start_date"
    t.index ["policy_type"], name: "index_life_insurances_on_policy_type"
    t.index ["sub_agent_id"], name: "index_life_insurances_on_sub_agent_id"
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
    t.text "notification_dates"
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
    t.text "notification_dates"
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

  create_table "sub_agent_documents", force: :cascade do |t|
    t.bigint "sub_agent_id", null: false
    t.string "document_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_agent_id", "document_type"], name: "index_sub_agent_documents_on_sub_agent_id_and_document_type"
    t.index ["sub_agent_id"], name: "index_sub_agent_documents_on_sub_agent_id"
  end

  create_table "sub_agents", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "mobile", null: false
    t.string "email", null: false
    t.integer "role_id", null: false
    t.integer "state_id"
    t.integer "city_id"
    t.date "birth_date"
    t.string "gender"
    t.string "pan_no"
    t.string "gst_no"
    t.string "company_name"
    t.text "address"
    t.string "bank_name"
    t.string "account_no"
    t.string "ifsc_code"
    t.string "account_holder_name"
    t.string "account_type"
    t.string "upi_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_sub_agents_on_email", unique: true
    t.index ["mobile"], name: "index_sub_agents_on_mobile", unique: true
    t.index ["role_id"], name: "index_sub_agents_on_role_id"
    t.index ["status"], name: "index_sub_agents_on_status"
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
  add_foreign_key "client_requests", "users", column: "resolved_by_id"
  add_foreign_key "corporate_members", "customers"
  add_foreign_key "family_members", "customers"
  add_foreign_key "health_insurance_members", "health_insurances"
  add_foreign_key "health_insurances", "agency_codes"
  add_foreign_key "health_insurances", "brokers"
  add_foreign_key "health_insurances", "customers"
  add_foreign_key "health_insurances", "policies"
  add_foreign_key "health_insurances", "sub_agents"
  add_foreign_key "life_insurances", "agency_codes"
  add_foreign_key "life_insurances", "brokers"
  add_foreign_key "life_insurances", "customers"
  add_foreign_key "life_insurances", "sub_agents"
  add_foreign_key "motor_insurances", "policies"
  add_foreign_key "other_insurances", "policies"
  add_foreign_key "policies", "agency_brokers"
  add_foreign_key "policies", "customers"
  add_foreign_key "policies", "insurance_companies"
  add_foreign_key "policies", "users"
  add_foreign_key "sub_agent_documents", "sub_agents"
end
