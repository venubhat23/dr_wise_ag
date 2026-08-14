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

ActiveRecord::Schema[8.0].define(version: 2026_08_14_000006) do
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
    t.index ["company_name"], name: "index_agency_codes_on_company_name"
    t.index ["insurance_type"], name: "index_agency_codes_on_insurance_type"
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
    t.index ["created_by_id"], name: "index_all_policy_reports_on_created_by_id"
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
    t.index ["display_start_date", "display_end_date"], name: "index_banners_on_display_start_date_and_display_end_date"
    t.index ["status"], name: "index_banners_on_status"
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
    t.bigint "vendor_id"
    t.datetime "status_updated_at"
    t.index ["created_at"], name: "index_client_services_on_created_at"
    t.index ["customer_id"], name: "index_client_services_on_customer_id"
    t.index ["distributor_id"], name: "index_client_services_on_distributor_id"
    t.index ["is_admin_added"], name: "index_client_services_on_is_admin_added"
    t.index ["service_category"], name: "index_client_services_on_service_category"
    t.index ["service_type"], name: "index_client_services_on_service_type"
    t.index ["status"], name: "index_client_services_on_status"
    t.index ["sub_agent_id"], name: "index_client_services_on_sub_agent_id"
    t.index ["vendor_id"], name: "index_client_services_on_vendor_id"
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
    t.index ["city_id"], name: "index_distributors_on_city_id"
    t.index ["created_at"], name: "index_distributors_on_created_at"
    t.index ["email"], name: "index_distributors_on_email", unique: true
    t.index ["investor_id"], name: "index_distributors_on_investor_id"
    t.index ["mobile"], name: "index_distributors_on_mobile", unique: true
    t.index ["role_id"], name: "index_distributors_on_role_id"
    t.index ["state_id"], name: "index_distributors_on_state_id"
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
    t.index ["is_admin_added", "is_customer_added", "is_agent_added", "policy_start_date"], name: "idx_health_insurances_drwise_policy_start_date"
    t.index ["is_admin_added", "is_customer_added", "is_agent_added"], name: "idx_health_insurances_drwise"
    t.index ["lead_id"], name: "index_health_insurances_on_lead_id", unique: true
    t.index ["original_policy_id"], name: "index_health_insurances_on_original_policy_id"
    t.index ["policy_booking_date"], name: "index_health_insurances_on_policy_booking_date"
    t.index ["policy_end_date", "created_at"], name: "index_health_insurances_on_policy_end_date_and_created_at"
    t.index ["policy_end_date"], name: "index_health_insurances_on_policy_end_date"
    t.index ["policy_id"], name: "index_health_insurances_on_policy_id"
    t.index ["policy_start_date"], name: "index_health_insurances_on_policy_start_date"
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
    t.index ["submitter_id"], name: "index_helpdesk_tickets_on_submitter_id"
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
    t.index ["insurance_type"], name: "index_insurance_companies_on_insurance_type"
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
    t.index ["first_name", "last_name"], name: "index_investors_on_first_name_and_last_name"
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
    t.index ["payout_type", "payout_id"], name: "index_invoice_items_on_payout_type_and_payout_id"
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
    t.index ["created_at"], name: "index_invoices_on_created_at"
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
    t.bigint "vendor_id"
    t.index ["affiliate_id"], name: "index_leads_on_affiliate_id"
    t.index ["ambassador_id"], name: "index_leads_on_ambassador_id"
    t.index ["company_name"], name: "index_leads_on_company_name"
    t.index ["contact_number"], name: "index_leads_on_contact_number"
    t.index ["converted_customer_id"], name: "index_leads_on_converted_customer_id"
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["created_date"], name: "index_leads_on_created_date"
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
    t.index ["vendor_id"], name: "index_leads_on_vendor_id"
  end
