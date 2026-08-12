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

ActiveRecord::Schema[8.0].define(version: 2026_06_28_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

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
    t.bigint "broker_id"
    t.index ["broker_id"], name: "index_agency_codes_on_broker_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "ai_report_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "report_type", null: false
    t.json "filters"
    t.json "ai_insights"
    t.integer "confidence_score"
    t.datetime "generated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confidence_score"], name: "index_ai_report_histories_on_confidence_score"
    t.index ["generated_at"], name: "index_ai_report_histories_on_generated_at"
    t.index ["report_type"], name: "index_ai_report_histories_on_report_type"
    t.index ["user_id", "report_type"], name: "index_ai_report_histories_on_user_id_and_report_type"
    t.index ["user_id"], name: "index_ai_report_histories_on_user_id"
  end

  create_table "all_policy_reports", force: :cascade do |t|
    t.string "name"
    t.string "policy_type"
    t.json "report_data"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analytics_caches", force: :cascade do |t|
    t.string "cache_identifier"
    t.text "cache_data"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cache_identifier"], name: "index_analytics_caches_on_cache_identifier", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "customer_name", null: false
    t.string "customer_email"
    t.string "customer_phone"
    t.text "meeting_agenda"
    t.text "notes"
    t.date "appointment_date", null: false
    t.string "time_slot", null: false
    t.string "status", default: "pending", null: false
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_date"], name: "index_appointments_on_appointment_date"
    t.index ["created_by_id"], name: "index_appointments_on_created_by_id"
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["status"], name: "index_appointments_on_status"
  end

  create_table "banner_documents", force: :cascade do |t|
    t.bigint "banner_id", null: false
    t.string "document_type"
    t.string "title"
    t.text "description"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.string "uploaded_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banner_id"], name: "index_banner_documents_on_banner_id"
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
    t.integer "display_order", default: 0
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.text "r2_public_url"
    t.index ["display_order"], name: "index_banners_on_display_order"
  end

  create_table "broker_codes", force: :cascade do |t|
    t.bigint "broker_id", null: false
    t.string "broker_code"
    t.string "company_name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "agent_name"
    t.index ["broker_id"], name: "index_broker_codes_on_broker_id"
  end

  create_table "brokers", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "insurance_company_id"
    t.index ["insurance_company_id"], name: "index_brokers_on_insurance_company_id"
    t.index ["name"], name: "index_brokers_on_name"
    t.index ["status"], name: "index_brokers_on_status"
  end

  create_table "client_requests", force: :cascade do |t|
    t.string "ticket_number", null: false
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
    t.string "category"
    t.string "submitter_type"
    t.integer "submitter_id"
    t.string "subject"
    t.string "request_type"
    t.index ["email"], name: "index_client_requests_on_email"
    t.index ["resolved_by_id"], name: "index_client_requests_on_resolved_by_id"
    t.index ["status"], name: "index_client_requests_on_status"
    t.index ["submitted_at"], name: "index_client_requests_on_submitted_at"
    t.index ["submitter_type", "submitter_id"], name: "index_client_requests_on_submitter_type_and_submitter_id"
    t.index ["ticket_number"], name: "index_client_requests_on_ticket_number", unique: true
  end

  create_table "client_services", force: :cascade do |t|
    t.string "service_type", null: false
    t.string "service_category", null: false
    t.bigint "customer_id", null: false
    t.bigint "sub_agent_id"
    t.bigint "distributor_id"
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.string "status", default: "pending"
    t.string "reference_number"
    t.date "start_date"
    t.text "notes"
    t.decimal "main_agent_commission_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_commission_percentage", precision: 8, scale: 2, default: "2.0"
    t.decimal "sub_agent_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "sub_agent_tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_commission_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "distributor_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "distributor_tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "investor_commission_percentage", precision: 8, scale: 2, default: "2.0"
    t.decimal "investor_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "company_expenses_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "company_expenses_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_distribution_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "profit_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "profit_amount", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin_added", default: false, null: false
    t.boolean "is_customer_added", default: true, null: false
    t.boolean "is_agent_added", default: false, null: false
    t.index ["customer_id"], name: "index_client_services_on_customer_id"
    t.index ["service_category"], name: "index_client_services_on_service_category"
    t.index ["service_type"], name: "index_client_services_on_service_type"
    t.index ["sub_agent_id"], name: "index_client_services_on_sub_agent_id"
  end

  create_table "commission_payouts", force: :cascade do |t|
    t.string "policy_type"
    t.integer "policy_id"
    t.string "payout_to"
    t.decimal "payout_amount"
    t.date "payout_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.string "payment_mode"
    t.string "reference_number"
    t.decimal "commission_amount_received", precision: 10, scale: 2
    t.decimal "distribution_percentage", precision: 5, scale: 2
    t.text "notes"
    t.string "processed_by"
    t.datetime "processed_at"
    t.bigint "payout_id"
    t.string "lead_id"
    t.boolean "invoiced", default: false
    t.decimal "total_commission_amount", precision: 10, scale: 2
    t.decimal "tds_amount", precision: 10, scale: 2
    t.index ["created_at"], name: "index_commission_payouts_on_created_at"
    t.index ["lead_id"], name: "index_commission_payouts_on_lead_id"
    t.index ["payout_date"], name: "index_commission_payouts_on_payout_date"
    t.index ["payout_id"], name: "index_commission_payouts_on_payout_id"
    t.index ["payout_to", "status"], name: "idx_commission_payouts_payout_to_status"
    t.index ["policy_type", "policy_id", "status"], name: "idx_commission_payouts_policy_status"
    t.index ["policy_type", "policy_id"], name: "idx_commission_payouts_policy"
    t.index ["status", "created_at"], name: "index_commission_payouts_on_status_and_created_at"
    t.index ["status"], name: "idx_commission_payouts_status"
  end

  create_table "commission_receipts", force: :cascade do |t|
    t.string "policy_type", null: false
    t.integer "policy_id", null: false
    t.decimal "total_commission_received", precision: 12, scale: 2, null: false
    t.date "received_date", null: false
    t.string "insurance_company_name"
    t.string "insurance_company_reference"
    t.decimal "company_commission_percentage", precision: 5, scale: 2
    t.string "payment_mode"
    t.string "transaction_id"
    t.text "notes"
    t.string "received_by"
    t.boolean "auto_distributed", default: false
    t.datetime "distributed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auto_distributed"], name: "index_commission_receipts_on_auto_distributed"
    t.index ["policy_type", "policy_id"], name: "index_commission_receipts_on_policy_type_and_policy_id", unique: true
    t.index ["received_date"], name: "index_commission_receipts_on_received_date"
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

  create_table "customer_documents", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.index ["customer_id"], name: "index_customer_documents_on_customer_id"
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
    t.integer "sub_agent_id"
    t.string "lead_id"
    t.boolean "deactivated", default: false
    t.string "r2_profile_image_key"
    t.string "r2_profile_image_filename"
    t.string "r2_profile_image_content_type"
    t.bigint "r2_profile_image_size"
    t.text "r2_profile_image_public_url"
    t.integer "policies_count", default: 0, null: false
    t.string "bank_name"
    t.string "account_no"
    t.string "ifsc_code"
    t.date "anniversary_date"
    t.index ["created_at"], name: "index_customers_on_created_at"
    t.index ["customer_type", "created_at"], name: "index_customers_on_customer_type_and_created_at"
    t.index ["customer_type", "status"], name: "index_customers_on_customer_type_and_status"
    t.index ["customer_type"], name: "index_customers_on_customer_type"
    t.index ["email"], name: "index_customers_on_email"
    t.index ["lead_id"], name: "index_customers_on_lead_id", unique: true
    t.index ["mobile"], name: "index_customers_on_mobile"
    t.index ["pan_number"], name: "index_customers_on_pan_number"
    t.index ["status", "created_at"], name: "index_customers_on_status_and_created_at"
    t.index ["status"], name: "index_customers_on_status"
    t.index ["sub_agent_id"], name: "index_customers_on_sub_agent_id"
  end

  create_table "distributor_assignments", force: :cascade do |t|
    t.bigint "distributor_id", null: false
    t.bigint "sub_agent_id", null: false
    t.datetime "assigned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["distributor_id"], name: "index_distributor_assignments_on_distributor_id"
    t.index ["sub_agent_id"], name: "index_distributor_assignments_on_sub_agent_id"
  end

  create_table "distributor_documents", force: :cascade do |t|
    t.bigint "distributor_id", null: false
    t.string "document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.index ["distributor_id"], name: "index_distributor_documents_on_distributor_id"
  end

  create_table "distributor_payouts", force: :cascade do |t|
    t.bigint "distributor_id", null: false
    t.string "policy_type"
    t.integer "policy_id"
    t.decimal "payout_amount", precision: 10, scale: 2
    t.date "payout_date"
    t.string "status", default: "pending"
    t.string "transaction_id"
    t.string "payment_mode"
    t.string "reference_number"
    t.text "notes"
    t.string "processed_by"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "invoiced", default: false
    t.index ["created_at"], name: "index_distributor_payouts_on_created_at"
    t.index ["distributor_id", "status"], name: "index_distributor_payouts_on_distributor_id_and_status"
    t.index ["distributor_id"], name: "index_distributor_payouts_on_distributor_id"
    t.index ["policy_type", "policy_id"], name: "index_distributor_payouts_on_policy_type_and_policy_id"
    t.index ["status", "created_at"], name: "index_distributor_payouts_on_status_and_created_at"
    t.index ["status"], name: "index_distributor_payouts_on_status"
  end

  create_table "distributors", force: :cascade do |t|
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
    t.integer "affiliate_count", default: 0, null: false
    t.boolean "deactivated", default: false
    t.string "city"
    t.string "state"
    t.string "username"
    t.string "password_digest"
    t.string "original_password"
    t.integer "investor_id"
    t.index ["created_at"], name: "index_distributors_on_created_at"
    t.index ["email"], name: "index_distributors_on_email", unique: true
    t.index ["investor_id"], name: "index_distributors_on_investor_id"
    t.index ["mobile"], name: "index_distributors_on_mobile", unique: true
    t.index ["role_id"], name: "index_distributors_on_role_id"
    t.index ["status"], name: "index_distributors_on_status"
  end

  create_table "documents", force: :cascade do |t|
    t.string "document_type"
    t.string "documentable_type", null: false
    t.bigint "documentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.string "uploaded_by"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
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

  create_table "health_insurance_documents", force: :cascade do |t|
    t.bigint "health_insurance_id", null: false
    t.string "document_type"
    t.string "title"
    t.text "description"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_insurance_id"], name: "index_health_insurance_documents_on_health_insurance_id"
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

  create_table "health_insurance_nominees", force: :cascade do |t|
    t.bigint "health_insurance_id", null: false
    t.string "nominee_name"
    t.string "relationship"
    t.integer "age"
    t.decimal "share_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_insurance_id"], name: "index_health_insurance_nominees_on_health_insurance_id"
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
    t.boolean "product_through_dr", default: true
    t.boolean "main_agent_commission_received", default: false
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.string "lead_id"
    t.bigint "distributor_id"
    t.bigint "investor_id"
    t.decimal "ambassador_commission_percentage"
    t.decimal "ambassador_commission_amount"
    t.decimal "ambassador_tds_percentage"
    t.decimal "ambassador_tds_amount"
    t.decimal "ambassador_after_tds_value"
    t.decimal "sub_agent_commission_percentage"
    t.decimal "sub_agent_commission_amount"
    t.decimal "sub_agent_tds_percentage"
    t.decimal "sub_agent_tds_amount"
    t.decimal "sub_agent_after_tds_value"
    t.decimal "investor_commission_percentage"
    t.decimal "investor_commission_amount"
    t.decimal "investor_tds_percentage"
    t.decimal "investor_tds_amount"
    t.decimal "investor_after_tds_value"
    t.decimal "company_expenses_percentage"
    t.decimal "total_distribution_percentage"
    t.decimal "profit_percentage"
    t.decimal "profit_amount"
    t.boolean "policy_added_by_admin", default: false
    t.date "nominee_dob"
    t.string "broker_code_type"
    t.string "insurance_company_code"
    t.string "main_policy_document_key"
    t.string "main_policy_document_filename"
    t.string "main_policy_document_content_type"
    t.bigint "main_policy_document_size"
    t.decimal "company_expenses_amount"
    t.boolean "is_renewed", default: false
    t.bigint "original_policy_id"
    t.string "premium_frequency", limit: 50
    t.string "status", limit: 50
    t.date "start_date"
    t.date "end_date"
    t.text "additional_details"
    t.string "nominee_name", limit: 255
    t.string "nominee_relation", limit: 100
    t.string "sum_insured_text", limit: 255
    t.index ["agency_code_id"], name: "index_health_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_health_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_health_insurances_created_at"
    t.index ["customer_id", "created_at"], name: "index_health_insurances_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_health_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_health_insurances_on_distributor_id"
    t.index ["insurance_company_code"], name: "index_health_insurances_on_insurance_company_code"
    t.index ["investor_id"], name: "index_health_insurances_on_investor_id"
    t.index ["is_admin_added", "is_customer_added", "is_agent_added"], name: "idx_health_insurances_drwise"
    t.index ["lead_id"], name: "index_health_insurances_on_lead_id", unique: true
    t.index ["policy_end_date", "created_at"], name: "index_health_insurances_on_policy_end_date_and_created_at"
    t.index ["policy_end_date"], name: "index_health_insurances_on_policy_end_date"
    t.index ["policy_id"], name: "index_health_insurances_on_policy_id"
    t.index ["policy_type"], name: "index_health_insurances_on_policy_type"
    t.index ["product_through_dr", "created_at"], name: "index_health_insurances_on_product_through_dr_and_created_at"
    t.index ["product_through_dr", "sum_insured"], name: "index_health_insurances_on_product_through_dr_and_sum_insured"
    t.index ["product_through_dr", "total_premium"], name: "idx_on_product_through_dr_total_premium_6bf60d17b1"
    t.index ["product_through_dr"], name: "index_health_insurances_on_product_through_dr"
    t.index ["status"], name: "index_health_insurances_on_status"
    t.index ["sub_agent_id"], name: "index_health_insurances_on_sub_agent_id"
  end

  create_table "helpdesk_tickets", force: :cascade do |t|
    t.string "ticket_number"
    t.string "subject"
    t.text "description"
    t.string "status"
    t.string "priority"
    t.string "category"
    t.string "submitter_type"
    t.integer "submitter_id"
    t.integer "assigned_to"
    t.text "resolution_notes"
    t.datetime "resolved_at"
    t.bigint "sub_agent_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_helpdesk_tickets_on_customer_id"
    t.index ["sub_agent_id"], name: "index_helpdesk_tickets_on_sub_agent_id"
    t.index ["ticket_number"], name: "index_helpdesk_tickets_on_ticket_number", unique: true
  end

  create_table "insurance_companies", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "contact_person"
    t.string "email"
    t.string "mobile"
    t.text "address"
    t.string "insurance_type"
    t.index ["code"], name: "idx_insurance_companies_code"
    t.index ["code"], name: "idx_insurance_companies_code_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["contact_person"], name: "idx_insurance_companies_contact_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["created_at"], name: "idx_insurance_companies_created_at"
    t.index ["name", "code", "contact_person"], name: "idx_insurance_companies_search_composite"
    t.index ["name", "id"], name: "idx_insurance_companies_name_id"
    t.index ["name"], name: "idx_insurance_companies_name"
    t.index ["name"], name: "idx_insurance_companies_name_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "idx_insurance_companies_status"
    t.index ["updated_at"], name: "idx_insurance_companies_updated_at"
  end

  create_table "investments", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "investment_type"
    t.string "product_name"
    t.decimal "investment_amount"
    t.boolean "status"
    t.date "investment_date"
    t.date "maturity_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_investments_on_customer_id"
  end

  create_table "investor_documents", force: :cascade do |t|
    t.bigint "investor_id", null: false
    t.string "document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.index ["investor_id"], name: "index_investor_documents_on_investor_id"
  end

  create_table "investors", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "mobile", null: false
    t.string "email", null: false
    t.integer "role_id", null: false
    t.string "state"
    t.string "city"
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
    t.string "password_digest"
    t.string "username"
    t.string "original_password"
    t.decimal "invested_amount"
    t.decimal "investment_percentage"
    t.string "main_document_key"
    t.string "main_document_filename"
    t.string "main_document_content_type"
    t.bigint "main_document_size"
    t.integer "number_of_shares"
    t.index ["email"], name: "index_investors_on_email", unique: true
    t.index ["mobile"], name: "index_investors_on_mobile", unique: true
    t.index ["role_id"], name: "index_investors_on_role_id"
    t.index ["status"], name: "index_investors_on_status"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "payout_type"
    t.integer "payout_id"
    t.string "description"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number", null: false
    t.string "payout_type", null: false
    t.integer "payout_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.date "invoice_date", null: false
    t.date "due_date", null: false
    t.datetime "paid_at"
    t.string "recipient_name"
    t.string "recipient_email"
    t.text "recipient_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_date"], name: "index_invoices_on_invoice_date"
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
    t.index ["payout_type", "payout_id"], name: "index_invoices_on_payout_type_and_payout_id"
    t.index ["status"], name: "index_invoices_on_status"
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
    t.string "lead_id"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "lead_source"
    t.string "call_disposition"
    t.decimal "referral_amount", precision: 10, scale: 2, default: "0.0"
    t.boolean "transferred_amount", default: false
    t.text "notes"
    t.text "attachments"
    t.datetime "stage_updated_at"
    t.integer "converted_customer_id"
    t.integer "policy_created_id"
    t.string "product_category"
    t.string "product_subcategory"
    t.boolean "is_direct", default: true
    t.integer "affiliate_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "gender"
    t.string "pan_no"
    t.string "gst_no"
    t.string "company_name"
    t.string "marital_status"
    t.string "height"
    t.string "weight"
    t.string "birth_place"
    t.string "education"
    t.string "business_job"
    t.string "business_name"
    t.string "job_name"
    t.string "occupation"
    t.string "type_of_duty"
    t.decimal "annual_income"
    t.text "additional_information"
    t.decimal "height_feet", precision: 3, scale: 1
    t.decimal "weight_kg", precision: 5, scale: 1
    t.string "business_job_type"
    t.string "business_job_name"
    t.string "duty_type"
    t.boolean "is_branch_out", default: false
    t.integer "ambassador_id"
    t.string "customer_type", default: "individual"
    t.integer "parent_lead_id"
    t.index ["affiliate_id"], name: "index_leads_on_affiliate_id"
    t.index ["ambassador_id"], name: "index_leads_on_ambassador_id"
    t.index ["company_name"], name: "index_leads_on_company_name"
    t.index ["contact_number"], name: "index_leads_on_contact_number"
    t.index ["converted_customer_id"], name: "index_leads_on_converted_customer_id"
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["current_stage", "created_at"], name: "index_leads_on_current_stage_and_created_at"
    t.index ["current_stage"], name: "index_leads_on_current_stage"
    t.index ["email"], name: "index_leads_on_email"
    t.index ["first_name", "last_name"], name: "index_leads_on_first_name_and_last_name"
    t.index ["is_direct"], name: "index_leads_on_is_direct"
    t.index ["lead_id"], name: "index_leads_on_lead_id", unique: true
    t.index ["lead_source"], name: "index_leads_on_lead_source"
    t.index ["parent_lead_id"], name: "index_leads_on_parent_lead_id"
    t.index ["policy_created_id"], name: "index_leads_on_policy_created_id"
    t.index ["product_category", "product_subcategory"], name: "index_leads_on_product_category_and_product_subcategory"
    t.index ["product_category"], name: "index_leads_on_product_category"
    t.index ["product_subcategory"], name: "index_leads_on_product_subcategory"
  end

  create_table "life_insurance_bank_details", force: :cascade do |t|
    t.bigint "life_insurance_id", null: false
    t.string "bank_name"
    t.string "account_type"
    t.string "account_number"
    t.string "ifsc_code"
    t.string "account_holder_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["life_insurance_id"], name: "index_life_insurance_bank_details_on_life_insurance_id"
  end

  create_table "life_insurance_documents", force: :cascade do |t|
    t.bigint "life_insurance_id", null: false
    t.string "document_type"
    t.string "document_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["life_insurance_id"], name: "index_life_insurance_documents_on_life_insurance_id"
  end

  create_table "life_insurance_nominees", force: :cascade do |t|
    t.bigint "life_insurance_id", null: false
    t.string "nominee_name"
    t.string "relationship"
    t.integer "age"
    t.decimal "share_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["life_insurance_id"], name: "index_life_insurance_nominees_on_life_insurance_id"
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
    t.bigint "distributor_id"
    t.bigint "investor_id"
    t.decimal "sub_agent_commission_percentage", precision: 5, scale: 2, default: "2.0"
    t.decimal "sub_agent_commission_amount", precision: 10, scale: 2
    t.decimal "distributor_commission_percentage", precision: 5, scale: 2, default: "1.0"
    t.decimal "distributor_commission_amount", precision: 10, scale: 2
    t.decimal "investor_commission_percentage", precision: 5, scale: 2, default: "2.0"
    t.decimal "investor_commission_amount", precision: 10, scale: 2
    t.decimal "main_income_percentage", precision: 5, scale: 2, default: "10.0"
    t.decimal "main_income_amount", precision: 10, scale: 2
    t.decimal "total_distribution_percentage", precision: 5, scale: 2
    t.decimal "company_expenses_percentage", precision: 5, scale: 2
    t.decimal "profit_percentage", precision: 5, scale: 2
    t.decimal "profit_amount", precision: 10, scale: 2
    t.decimal "sub_agent_tds_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "sub_agent_tds_amount", precision: 10, scale: 2
    t.decimal "sub_agent_after_tds_value", precision: 10, scale: 2
    t.decimal "distributor_tds_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "distributor_tds_amount", precision: 10, scale: 2
    t.decimal "distributor_after_tds_value", precision: 10, scale: 2
    t.decimal "investor_tds_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "investor_tds_amount", precision: 10, scale: 2
    t.decimal "investor_after_tds_value", precision: 10, scale: 2
    t.boolean "product_through_dr", default: true
    t.boolean "main_agent_commission_received", default: false
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.string "lead_id"
    t.decimal "ambassador_commission_percentage"
    t.decimal "ambassador_commission_amount"
    t.decimal "ambassador_tds_percentage"
    t.decimal "ambassador_tds_amount"
    t.decimal "ambassador_after_tds_value"
    t.string "broker_code_type"
    t.boolean "policy_added_by_admin", default: false
    t.integer "original_policy_id"
    t.integer "renewal_policy_id"
    t.boolean "is_renewed", default: false, null: false
    t.string "insurance_company_code"
    t.string "main_policy_document_key"
    t.string "main_policy_document_filename"
    t.string "main_policy_document_content_type"
    t.bigint "main_policy_document_size"
    t.index ["agency_code_id"], name: "index_life_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_life_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_life_insurances_created_at"
    t.index ["customer_id", "created_at"], name: "index_life_insurances_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_life_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_life_insurances_on_distributor_id"
    t.index ["insurance_company_code"], name: "index_life_insurances_on_insurance_company_code"
    t.index ["insurance_company_name"], name: "index_life_insurances_on_insurance_company_name"
    t.index ["investor_id"], name: "index_life_insurances_on_investor_id"
    t.index ["is_admin_added", "is_customer_added", "is_agent_added"], name: "idx_life_insurances_drwise"
    t.index ["is_renewed"], name: "index_life_insurances_on_is_renewed"
    t.index ["lead_id"], name: "index_life_insurances_on_lead_id", unique: true
    t.index ["original_policy_id"], name: "index_life_insurances_on_original_policy_id"
    t.index ["policy_end_date", "created_at"], name: "index_life_insurances_on_policy_end_date_and_created_at"
    t.index ["policy_end_date"], name: "index_life_insurances_on_policy_end_date"
    t.index ["policy_number"], name: "index_life_insurances_on_policy_number", unique: true
    t.index ["policy_start_date", "policy_end_date"], name: "index_life_insurances_on_policy_start_date_and_policy_end_date"
    t.index ["policy_start_date"], name: "index_life_insurances_on_policy_start_date"
    t.index ["policy_type"], name: "index_life_insurances_on_policy_type"
    t.index ["product_through_dr", "created_at"], name: "index_life_insurances_on_product_through_dr_and_created_at"
    t.index ["product_through_dr", "sum_insured"], name: "index_life_insurances_on_product_through_dr_and_sum_insured"
    t.index ["product_through_dr", "total_premium"], name: "index_life_insurances_on_product_through_dr_and_total_premium"
    t.index ["product_through_dr"], name: "index_life_insurances_on_product_through_dr"
    t.index ["renewal_policy_id"], name: "index_life_insurances_on_renewal_policy_id"
    t.index ["sub_agent_id"], name: "index_life_insurances_on_sub_agent_id"
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "loan_type"
    t.decimal "loan_amount"
    t.decimal "interest_rate"
    t.integer "loan_term"
    t.decimal "emi_amount"
    t.date "loan_date"
    t.boolean "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_loans_on_customer_id"
  end

  create_table "motor_insurance_documents", force: :cascade do |t|
    t.bigint "motor_insurance_id", null: false
    t.string "document_type"
    t.string "title"
    t.text "description"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "r2_url"
    t.index ["motor_insurance_id"], name: "index_motor_insurance_documents_on_motor_insurance_id"
  end

  create_table "motor_insurance_nominees", force: :cascade do |t|
    t.bigint "motor_insurance_id", null: false
    t.string "nominee_name"
    t.string "relationship"
    t.integer "age"
    t.decimal "share_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["motor_insurance_id"], name: "index_motor_insurance_nominees_on_motor_insurance_id"
  end

  create_table "motor_insurances", force: :cascade do |t|
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
    t.decimal "main_agent_tds_percentage"
    t.decimal "main_agent_tds_amount"
    t.string "broker_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notification_dates"
    t.date "policy_end_date"
    t.date "policy_start_date"
    t.date "policy_booking_date"
    t.string "insurance_company_name"
    t.string "policy_holder"
    t.string "policy_type"
    t.decimal "gst_percentage", precision: 8, scale: 2, default: "18.0"
    t.decimal "net_premium", precision: 10, scale: 2
    t.decimal "gst_amount", precision: 10, scale: 2
    t.decimal "after_tds_value", precision: 10, scale: 2
    t.boolean "is_customer_added", default: false
    t.boolean "is_agent_added", default: false
    t.boolean "is_admin_added", default: false
    t.string "reference_by_name"
    t.text "extra_note"
    t.bigint "customer_id", null: false
    t.bigint "sub_agent_id"
    t.bigint "agency_code_id"
    t.bigint "broker_id"
    t.string "insurance_type"
    t.decimal "total_premium", precision: 10, scale: 2
    t.string "policy_number"
    t.decimal "sum_insured"
    t.boolean "status"
    t.boolean "product_through_dr", default: false
    t.boolean "main_agent_commission_received", default: false
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.string "lead_id"
    t.bigint "distributor_id"
    t.bigint "investor_id"
    t.decimal "sub_agent_commission_percentage", precision: 8, scale: 2
    t.decimal "sub_agent_commission_amount", precision: 12, scale: 2
    t.decimal "sub_agent_tds_percentage", precision: 8, scale: 2
    t.decimal "sub_agent_tds_amount", precision: 12, scale: 2
    t.decimal "sub_agent_after_tds_value", precision: 12, scale: 2
    t.decimal "distributor_commission_percentage", precision: 8, scale: 2
    t.decimal "distributor_commission_amount", precision: 12, scale: 2
    t.decimal "distributor_tds_percentage", precision: 8, scale: 2
    t.decimal "distributor_tds_amount", precision: 12, scale: 2
    t.decimal "distributor_after_tds_value", precision: 12, scale: 2
    t.decimal "investor_commission_percentage", precision: 8, scale: 2
    t.decimal "investor_commission_amount", precision: 12, scale: 2
    t.decimal "investor_tds_percentage", precision: 8, scale: 2
    t.decimal "investor_tds_amount", precision: 12, scale: 2
    t.decimal "investor_after_tds_value", precision: 12, scale: 2
    t.decimal "ambassador_commission_percentage", precision: 8, scale: 2
    t.decimal "ambassador_commission_amount", precision: 12, scale: 2
    t.decimal "ambassador_tds_percentage", precision: 8, scale: 2
    t.decimal "ambassador_tds_amount", precision: 12, scale: 2
    t.decimal "ambassador_after_tds_value", precision: 12, scale: 2
    t.decimal "total_distribution_percentage", precision: 8, scale: 2
    t.decimal "company_expenses_percentage", precision: 8, scale: 2
    t.decimal "profit_percentage", precision: 8, scale: 2
    t.decimal "profit_amount", precision: 12, scale: 2
    t.decimal "commission_amount", precision: 12, scale: 2
    t.decimal "tds_percentage", precision: 8, scale: 2
    t.decimal "tds_amount", precision: 12, scale: 2
    t.decimal "main_agent_commission_percentage", precision: 8, scale: 2
    t.boolean "policy_added_by_admin", default: false
    t.string "payment_mode"
    t.string "plan_name"
    t.string "broker_code_type"
    t.date "installment_autopay_start_date"
    t.date "installment_autopay_end_date"
    t.string "nominee_name"
    t.string "nominee_relation"
    t.date "nominee_dob"
    t.string "insurance_company_code"
    t.decimal "company_expenses_amount"
    t.string "main_policy_document_key"
    t.string "main_policy_document_filename"
    t.string "main_policy_document_content_type"
    t.bigint "main_policy_document_size"
    t.string "main_policy_document_url"
    t.string "vehicle_number", limit: 255
    t.string "vehicle_make", limit: 255
    t.string "vehicle_model", limit: 255
    t.index ["agency_code_id"], name: "index_motor_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_motor_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_motor_insurances_created_at"
    t.index ["customer_id", "created_at"], name: "index_motor_insurances_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_motor_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_motor_insurances_on_distributor_id"
    t.index ["insurance_company_code"], name: "index_motor_insurances_on_insurance_company_code"
    t.index ["investor_id"], name: "index_motor_insurances_on_investor_id"
    t.index ["is_admin_added", "is_customer_added", "is_agent_added"], name: "idx_motor_insurances_drwise"
    t.index ["lead_id"], name: "index_motor_insurances_on_lead_id", unique: true
    t.index ["policy_end_date", "created_at"], name: "index_motor_insurances_on_policy_end_date_and_created_at"
    t.index ["policy_end_date"], name: "index_motor_insurances_on_policy_end_date"
    t.index ["policy_number"], name: "index_motor_insurances_on_policy_number", unique: true
    t.index ["policy_type"], name: "index_motor_insurances_on_policy_type"
    t.index ["sub_agent_id"], name: "index_motor_insurances_on_sub_agent_id"
  end

  create_table "mutual_fund_nominees", force: :cascade do |t|
    t.bigint "mutual_fund_id", null: false
    t.string "nominee_name", null: false
    t.string "relationship"
    t.integer "age"
    t.decimal "share_percentage", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mutual_fund_id"], name: "index_mutual_fund_nominees_on_mutual_fund_id"
  end

  create_table "mutual_funds", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "sub_agent_id"
    t.bigint "distributor_id"
    t.string "investment_type", null: false
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "fund_name"
    t.string "folio_number"
    t.string "plan_name"
    t.date "start_date"
    t.date "maturity_date"
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
    t.decimal "main_agent_commission_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_commission_percentage", precision: 8, scale: 2, default: "2.0"
    t.decimal "sub_agent_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "sub_agent_tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "sub_agent_after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_commission_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "distributor_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_tds_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "distributor_tds_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "distributor_after_tds_value", precision: 15, scale: 2, default: "0.0"
    t.decimal "investor_commission_percentage", precision: 8, scale: 2, default: "2.0"
    t.decimal "investor_commission_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "company_expenses_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "company_expenses_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_distribution_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "profit_percentage", precision: 8, scale: 2, default: "0.0"
    t.decimal "profit_amount", precision: 15, scale: 2, default: "0.0"
    t.string "main_policy_document_key"
    t.string "main_policy_document_filename"
    t.string "main_policy_document_content_type"
    t.bigint "main_policy_document_size"
    t.date "installment_autopay_start_date"
    t.date "installment_autopay_end_date"
    t.boolean "is_admin_added", default: false
    t.boolean "is_customer_added", default: false
    t.boolean "is_agent_added", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_mutual_funds_on_customer_id"
    t.index ["distributor_id"], name: "index_mutual_funds_on_distributor_id"
    t.index ["sub_agent_id"], name: "index_mutual_funds_on_sub_agent_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type"
    t.integer "recipient_id"
    t.string "notification_type"
    t.string "title"
    t.text "message"
    t.string "reference_type"
    t.integer "reference_id"
    t.boolean "is_read"
    t.datetime "sent_at"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_read"], name: "index_notifications_on_is_read"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
    t.index ["reference_type", "reference_id"], name: "index_notifications_on_reference_type_and_reference_id"
    t.index ["sent_at"], name: "index_notifications_on_sent_at"
  end

  create_table "other_insurance_documents", force: :cascade do |t|
    t.bigint "other_insurance_id", null: false
    t.string "document_type"
    t.string "title"
    t.text "description"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["other_insurance_id"], name: "index_other_insurance_documents_on_other_insurance_id"
  end

  create_table "other_insurance_nominees", force: :cascade do |t|
    t.bigint "other_insurance_id", null: false
    t.string "nominee_name"
    t.string "relationship"
    t.integer "age"
    t.decimal "share_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["other_insurance_id"], name: "index_other_insurance_nominees_on_other_insurance_id"
  end

  create_table "other_insurances", force: :cascade do |t|
    t.bigint "policy_id"
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
    t.date "policy_end_date"
    t.date "policy_start_date"
    t.date "policy_booking_date"
    t.boolean "product_through_dr", default: false
    t.boolean "main_agent_commission_received", default: false
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.string "lead_id"
    t.bigint "distributor_id"
    t.bigint "investor_id"
    t.string "policy_holder"
    t.string "broker_code_type"
    t.integer "agency_code_id"
    t.integer "broker_id"
    t.decimal "gst_percentage"
    t.string "payment_mode"
    t.string "plan_name"
    t.string "policy_term"
    t.string "claim_process"
    t.decimal "commission_amount"
    t.decimal "tds_percentage"
    t.decimal "tds_amount"
    t.decimal "after_tds_value"
    t.decimal "sub_agent_commission_percentage"
    t.decimal "sub_agent_commission_amount"
    t.decimal "sub_agent_tds_percentage"
    t.decimal "sub_agent_tds_amount"
    t.decimal "sub_agent_after_tds_value"
    t.decimal "investor_commission_percentage"
    t.decimal "investor_commission_amount"
    t.decimal "investor_tds_percentage"
    t.decimal "investor_tds_amount"
    t.decimal "investor_after_tds_value"
    t.decimal "ambassador_commission_percentage"
    t.decimal "ambassador_commission_amount"
    t.decimal "ambassador_tds_percentage"
    t.decimal "ambassador_tds_amount"
    t.decimal "ambassador_after_tds_value"
    t.decimal "company_expenses_percentage"
    t.decimal "total_distribution_percentage"
    t.decimal "profit_percentage"
    t.decimal "profit_amount"
    t.date "installment_autopay_start_date"
    t.date "installment_autopay_end_date"
    t.decimal "main_agent_commission_percentage"
    t.string "policy_type"
    t.boolean "is_customer_added", default: false
    t.boolean "is_agent_added", default: false
    t.boolean "is_admin_added", default: false
    t.boolean "policy_added_by_admin", default: false
    t.boolean "is_renewed"
    t.integer "original_policy_id"
    t.string "insurance_company_code"
    t.string "main_policy_document_key"
    t.string "main_policy_document_filename"
    t.string "main_policy_document_content_type"
    t.bigint "main_policy_document_size"
    t.decimal "company_expenses_amount"
    t.decimal "total_premium", precision: 15, scale: 2, default: "0.0"
    t.decimal "net_premium", precision: 15, scale: 2, default: "0.0"
    t.decimal "sum_insured", precision: 15, scale: 2
    t.string "insurance_company_name", limit: 255
    t.bigint "customer_id"
    t.string "insurance_type", limit: 255
    t.integer "sub_agent_id"
    t.string "policy_number", limit: 255
    t.index ["created_at"], name: "idx_other_insurances_created_at"
    t.index ["customer_id", "created_at"], name: "index_other_insurances_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_other_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_other_insurances_on_distributor_id"
    t.index ["insurance_company_code"], name: "index_other_insurances_on_insurance_company_code"
    t.index ["investor_id"], name: "index_other_insurances_on_investor_id"
    t.index ["is_admin_added", "is_customer_added", "is_agent_added"], name: "idx_other_insurances_drwise"
    t.index ["lead_id"], name: "index_other_insurances_on_lead_id", unique: true
    t.index ["policy_end_date", "created_at"], name: "index_other_insurances_on_policy_end_date_and_created_at"
    t.index ["policy_end_date"], name: "index_other_insurances_on_policy_end_date"
    t.index ["policy_id"], name: "index_other_insurances_on_policy_id"
    t.index ["sub_agent_id"], name: "index_other_insurances_on_sub_agent_id"
  end

  create_table "payout_audit_logs", force: :cascade do |t|
    t.string "auditable_type"
    t.integer "auditable_id"
    t.string "action"
    t.json "changes"
    t.string "performed_by"
    t.string "ip_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_payout_audit_logs_on_auditable_type_and_auditable_id"
    t.index ["created_at"], name: "index_payout_audit_logs_on_created_at"
    t.index ["performed_by"], name: "index_payout_audit_logs_on_performed_by"
  end

  create_table "payout_distributions", force: :cascade do |t|
    t.bigint "commission_receipt_id", null: false
    t.string "recipient_type", null: false
    t.integer "recipient_id"
    t.decimal "distribution_percentage", precision: 5, scale: 2, null: false
    t.decimal "calculated_amount", precision: 10, scale: 2, null: false
    t.decimal "paid_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "pending_amount", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "pending"
    t.date "payment_date"
    t.string "payment_mode"
    t.string "transaction_id"
    t.string "reference_number"
    t.text "payment_notes"
    t.string "processed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commission_receipt_id"], name: "index_payout_distributions_on_commission_receipt_id"
    t.index ["payment_date"], name: "index_payout_distributions_on_payment_date"
    t.index ["recipient_type", "recipient_id"], name: "index_payout_distributions_on_recipient_type_and_recipient_id"
    t.index ["status"], name: "index_payout_distributions_on_status"
  end

  create_table "payouts", force: :cascade do |t|
    t.string "policy_type"
    t.integer "policy_id"
    t.integer "customer_id"
    t.decimal "total_commission_amount"
    t.string "status"
    t.date "payout_date"
    t.string "processed_by"
    t.datetime "processed_at"
    t.text "notes"
    t.string "reference_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "main_agent_percentage", precision: 8, scale: 2
    t.decimal "main_agent_commission_amount", precision: 10, scale: 2
    t.integer "main_agent_commission_id"
    t.decimal "affiliate_percentage", precision: 8, scale: 2
    t.decimal "affiliate_commission_amount", precision: 10, scale: 2
    t.integer "affiliate_commission_id"
    t.decimal "ambassador_percentage", precision: 8, scale: 2
    t.decimal "ambassador_commission_amount", precision: 10, scale: 2
    t.integer "ambassador_commission_id"
    t.decimal "investor_percentage", precision: 8, scale: 2
    t.decimal "investor_commission_amount", precision: 10, scale: 2
    t.integer "investor_commission_id"
    t.decimal "company_expense_percentage", precision: 8, scale: 2
    t.decimal "company_expense_amount", precision: 10, scale: 2
    t.integer "company_expense_commission_id"
    t.text "commission_summary"
    t.decimal "net_premium"
    t.boolean "main_agent_commission_received"
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.index ["affiliate_commission_id"], name: "index_payouts_on_affiliate_commission_id"
    t.index ["ambassador_commission_id"], name: "index_payouts_on_ambassador_commission_id"
    t.index ["company_expense_commission_id"], name: "index_payouts_on_company_expense_commission_id"
    t.index ["created_at"], name: "index_payouts_on_created_at"
    t.index ["customer_id"], name: "index_payouts_on_customer_id"
    t.index ["investor_commission_id"], name: "index_payouts_on_investor_commission_id"
    t.index ["main_agent_commission_id"], name: "index_payouts_on_main_agent_commission_id"
    t.index ["policy_type", "policy_id"], name: "idx_payouts_policy"
    t.index ["policy_type", "policy_id"], name: "index_payouts_on_policy_type_and_id"
    t.index ["status"], name: "index_payouts_on_status"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "module_name", limit: 50, null: false
    t.string "action_type", limit: 20, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_type"], name: "index_permissions_on_action_type"
    t.index ["module_name", "action_type"], name: "index_permissions_on_module_name_and_action_type", unique: true
    t.index ["module_name"], name: "index_permissions_on_module_name"
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
    t.string "policy_holder"
    t.index ["agency_broker_id"], name: "index_policies_on_agency_broker_id"
    t.index ["customer_id", "created_at"], name: "index_policies_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_policies_on_customer_id"
    t.index ["insurance_company_id"], name: "index_policies_on_insurance_company_id"
    t.index ["insurance_type"], name: "index_policies_on_insurance_type"
    t.index ["policy_end_date"], name: "index_policies_on_policy_end_date"
    t.index ["policy_start_date"], name: "index_policies_on_policy_start_date"
    t.index ["status"], name: "index_policies_on_status"
    t.index ["user_id"], name: "index_policies_on_user_id"
  end

  create_table "policy_documents", force: :cascade do |t|
    t.string "policy_type", null: false
    t.integer "policy_id", null: false
    t.string "document_type", null: false
    t.string "title", null: false
    t.text "description"
    t.string "uploaded_by"
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_policy_documents_on_created_at"
    t.index ["document_type"], name: "index_policy_documents_on_document_type"
    t.index ["policy_type", "policy_id"], name: "index_policy_documents_on_policy_type_and_policy_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name"
    t.string "report_type"
    t.text "filters"
    t.text "report_data"
    t.boolean "status"
    t.datetime "generated_at"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "idx_role_permissions_permission"
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "idx_role_permissions_unique", unique: true
    t.index ["role_id"], name: "idx_role_permissions_role"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text "description"
    t.boolean "status", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
    t.index ["status"], name: "index_roles_on_status"
  end

  create_table "session_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "activity_type"
    t.datetime "occurred_at"
    t.string "ip_address"
    t.text "user_agent"
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_session_activities_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "sub_agent_documents", force: :cascade do |t|
    t.bigint "sub_agent_id", null: false
    t.string "document_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "r2_file_key"
    t.string "r2_filename"
    t.string "r2_content_type"
    t.bigint "r2_file_size"
    t.index ["document_type"], name: "index_sub_agent_documents_on_document_type"
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
    t.string "password_digest"
    t.bigint "distributor_id"
    t.string "plain_password"
    t.string "original_password"
    t.datetime "password_reset_at"
    t.boolean "deactivated", default: false
    t.string "city"
    t.string "state"
    t.index ["created_at"], name: "index_sub_agents_on_created_at"
    t.index ["distributor_id"], name: "index_sub_agents_on_distributor_id"
    t.index ["email"], name: "index_sub_agents_on_email", unique: true
    t.index ["mobile"], name: "index_sub_agents_on_mobile", unique: true
    t.index ["role_id"], name: "index_sub_agents_on_role_id"
    t.index ["status"], name: "index_sub_agents_on_status"
  end

  create_table "system_settings", force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.text "description"
    t.string "setting_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "default_main_agent_commission", precision: 5, scale: 2
    t.decimal "default_affiliate_commission", precision: 5, scale: 2
    t.decimal "default_ambassador_commission", precision: 5, scale: 2
    t.decimal "default_company_expenses", precision: 5, scale: 2
    t.text "terms_and_conditions"
    t.decimal "investment_amount", precision: 15, scale: 2, default: "0.0"
    t.string "company_name"
    t.string "company_phone"
    t.string "company_email"
    t.text "company_address"
    t.index ["key"], name: "index_system_settings_on_key", unique: true
  end

  create_table "tax_services", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "service_type"
    t.string "financial_year"
    t.date "filing_date"
    t.decimal "amount"
    t.boolean "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_tax_services_on_customer_id"
  end

  create_table "travel_packages", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "travel_type"
    t.string "destination"
    t.date "travel_date"
    t.date "return_date"
    t.decimal "package_amount"
    t.boolean "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_travel_packages_on_customer_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "status", default: true, null: false
    t.integer "display_order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_user_roles_on_display_order"
    t.index ["name"], name: "index_user_roles_on_name", unique: true
    t.index ["status"], name: "index_user_roles_on_status"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "session_id", null: false
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.integer "duration"
    t.string "status", default: "active"
    t.string "location"
    t.string "device_type"
    t.string "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_user_sessions_on_ip_address"
    t.index ["session_id"], name: "index_user_sessions_on_session_id", unique: true
    t.index ["started_at"], name: "index_user_sessions_on_started_at"
    t.index ["status"], name: "index_user_sessions_on_status"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
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
    t.bigint "role_id"
    t.bigint "user_role_id"
    t.string "plain_password"
    t.string "original_password"
    t.text "sidebar_permissions"
    t.string "role_name"
    t.datetime "password_reset_at", comment: "When password was last reset"
    t.text "crud_permissions"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "idx_users_role_id"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agency_codes", "brokers"
  add_foreign_key "ai_report_histories", "users"
  add_foreign_key "appointments", "customers"
  add_foreign_key "appointments", "users", column: "created_by_id"
  add_foreign_key "banner_documents", "banners"
  add_foreign_key "broker_codes", "brokers"
  add_foreign_key "brokers", "insurance_companies"
  add_foreign_key "client_requests", "users", column: "resolved_by_id"
  add_foreign_key "commission_payouts", "payouts"
  add_foreign_key "corporate_members", "customers"
  add_foreign_key "customer_documents", "customers"
  add_foreign_key "customers", "sub_agents"
  add_foreign_key "distributor_assignments", "distributors"
  add_foreign_key "distributor_assignments", "sub_agents"
  add_foreign_key "distributor_documents", "distributors"
  add_foreign_key "distributor_payouts", "distributors"
  add_foreign_key "family_members", "customers"
  add_foreign_key "health_insurance_documents", "health_insurances"
  add_foreign_key "health_insurance_members", "health_insurances"
  add_foreign_key "health_insurance_nominees", "health_insurances"
  add_foreign_key "health_insurances", "agency_codes"
  add_foreign_key "health_insurances", "brokers"
  add_foreign_key "health_insurances", "customers"
  add_foreign_key "health_insurances", "distributors"
  add_foreign_key "health_insurances", "health_insurances", column: "original_policy_id", name: "health_insurances_original_policy_id_fkey"
  add_foreign_key "health_insurances", "investors"
  add_foreign_key "health_insurances", "policies"
  add_foreign_key "health_insurances", "sub_agents"
  add_foreign_key "helpdesk_tickets", "customers"
  add_foreign_key "helpdesk_tickets", "sub_agents"
  add_foreign_key "investments", "customers"
  add_foreign_key "investor_documents", "investors"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "leads", "distributors", column: "ambassador_id"
  add_foreign_key "life_insurance_bank_details", "life_insurances"
  add_foreign_key "life_insurance_documents", "life_insurances"
  add_foreign_key "life_insurance_nominees", "life_insurances"
  add_foreign_key "life_insurances", "agency_codes"
  add_foreign_key "life_insurances", "brokers"
  add_foreign_key "life_insurances", "customers"
  add_foreign_key "life_insurances", "distributors"
  add_foreign_key "life_insurances", "investors"
  add_foreign_key "life_insurances", "sub_agents"
  add_foreign_key "loans", "customers"
  add_foreign_key "motor_insurance_documents", "motor_insurances"
  add_foreign_key "motor_insurance_nominees", "motor_insurances"
  add_foreign_key "motor_insurances", "agency_codes"
  add_foreign_key "motor_insurances", "brokers"
  add_foreign_key "motor_insurances", "customers"
  add_foreign_key "motor_insurances", "distributors"
  add_foreign_key "motor_insurances", "investors"
  add_foreign_key "motor_insurances", "sub_agents"
  add_foreign_key "mutual_fund_nominees", "mutual_funds"
  add_foreign_key "mutual_funds", "customers"
  add_foreign_key "mutual_funds", "distributors"
  add_foreign_key "mutual_funds", "sub_agents"
  add_foreign_key "other_insurance_documents", "other_insurances"
  add_foreign_key "other_insurance_nominees", "other_insurances"
  add_foreign_key "other_insurances", "distributors"
  add_foreign_key "other_insurances", "investors"
  add_foreign_key "other_insurances", "policies"
  add_foreign_key "payout_distributions", "commission_receipts"
  add_foreign_key "policies", "agency_brokers"
  add_foreign_key "policies", "customers"
  add_foreign_key "policies", "insurance_companies"
  add_foreign_key "policies", "users"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "session_activities", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "sub_agent_documents", "sub_agents"
  add_foreign_key "sub_agents", "distributors"
  add_foreign_key "tax_services", "customers"
  add_foreign_key "travel_packages", "customers"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "user_roles"
end
