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

ActiveRecord::Schema[8.0].define(version: 2026_01_15_155330) do
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
    t.bigint "broker_id"
    t.index ["broker_id"], name: "index_agency_codes_on_broker_id"
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
    t.index ["display_order"], name: "index_banners_on_display_order"
  end

  create_table "broker_codes", force: :cascade do |t|
    t.bigint "broker_id", null: false
    t.string "agent_name"
    t.string "broker_code"
    t.string "company_name"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agency_code_id"
    t.index ["agency_code_id"], name: "index_broker_codes_on_agency_code_id"
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
    t.string "subject"
    t.string "request_type"
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
    t.index ["ticket_number"], name: "index_client_requests_on_ticket_number", unique: true
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
    t.index ["lead_id"], name: "index_commission_payouts_on_lead_id"
    t.index ["payout_date"], name: "index_commission_payouts_on_payout_date"
    t.index ["payout_id"], name: "index_commission_payouts_on_payout_id"
    t.index ["payout_to", "status"], name: "idx_commission_payouts_payout_to_status"
    t.index ["payout_to", "status"], name: "index_commission_payouts_on_payout_to_and_status"
    t.index ["policy_type", "policy_id", "status"], name: "idx_commission_payouts_policy_status"
    t.index ["policy_type", "policy_id"], name: "idx_commission_payouts_policy"
    t.index ["policy_type", "policy_id"], name: "index_commission_payouts_on_policy_type_and_policy_id"
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
    t.integer "policies_count", default: 0, null: false
    t.integer "sub_agent_id"
    t.string "lead_id"
    t.boolean "deactivated", default: false
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
    t.index ["distributor_id", "status"], name: "index_distributor_payouts_on_distributor_id_and_status"
    t.index ["distributor_id"], name: "index_distributor_payouts_on_distributor_id"
    t.index ["policy_type", "policy_id"], name: "index_distributor_payouts_on_policy_type_and_policy_id"
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
    t.index ["email"], name: "index_distributors_on_email", unique: true
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
    t.boolean "product_through_dr", default: false
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
    t.index ["agency_code_id"], name: "index_health_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_health_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_health_insurances_created_at"
    t.index ["customer_id"], name: "index_health_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_health_insurances_on_distributor_id"
    t.index ["investor_id"], name: "index_health_insurances_on_investor_id"
    t.index ["lead_id"], name: "index_health_insurances_on_lead_id", unique: true
    t.index ["policy_id"], name: "index_health_insurances_on_policy_id"
    t.index ["sub_agent_id"], name: "index_health_insurances_on_sub_agent_id"
  end
