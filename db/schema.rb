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

ActiveRecord::Schema[8.0].define(version: 2025_12_28_154545) do
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

  create_table "indian_locations", force: :cascade do |t|
    t.string "state", null: false
    t.string "city", null: false
    t.string "district"
    t.string "pincode"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_active"], name: "index_indian_locations_on_is_active"
    t.index ["state", "city"], name: "index_indian_locations_on_state_and_city", unique: true
    t.index ["state"], name: "index_indian_locations_on_state"
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
    t.index ["investor_id"], name: "index_investor_documents_on_investor_id"
  end

  create_table "investors", force: :cascade do |t|
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
    t.index ["email"], name: "index_investors_on_email", unique: true
    t.index ["mobile"], name: "index_investors_on_mobile", unique: true
    t.index ["role_id"], name: "index_investors_on_role_id"
    t.index ["status"], name: "index_investors_on_status"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number"
    t.string "payout_type"
    t.integer "payout_id"
    t.decimal "total_amount"
    t.string "status"
    t.date "invoice_date"
    t.date "due_date"
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
    t.string "customer_type"
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
    t.index ["affiliate_id"], name: "index_leads_on_affiliate_id"
    t.index ["converted_customer_id"], name: "index_leads_on_converted_customer_id"
    t.index ["current_stage"], name: "index_leads_on_current_stage"
    t.index ["lead_id"], name: "index_leads_on_lead_id", unique: true
    t.index ["lead_source"], name: "index_leads_on_lead_source"
    t.index ["policy_created_id"], name: "index_leads_on_policy_created_id"
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
    t.boolean "product_through_dr", default: false
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
    t.index ["agency_code_id"], name: "index_life_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_life_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_life_insurances_created_at"
    t.index ["customer_id"], name: "index_life_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_life_insurances_on_distributor_id"
    t.index ["insurance_company_name"], name: "index_life_insurances_on_insurance_company_name"
    t.index ["investor_id"], name: "index_life_insurances_on_investor_id"
    t.index ["lead_id"], name: "index_life_insurances_on_lead_id", unique: true
    t.index ["policy_end_date"], name: "index_life_insurances_on_policy_end_date"
    t.index ["policy_number"], name: "index_life_insurances_on_policy_number", unique: true
    t.index ["policy_start_date", "policy_end_date"], name: "index_life_insurances_on_policy_start_date_and_policy_end_date"
    t.index ["policy_start_date"], name: "index_life_insurances_on_policy_start_date"
    t.index ["policy_type"], name: "index_life_insurances_on_policy_type"
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
    t.decimal "main_agent_tds_percent"
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
    t.bigint "distributor_id"
    t.string "lead_id"
    t.bigint "investor_id"
    t.index ["agency_code_id"], name: "index_motor_insurances_on_agency_code_id"
    t.index ["broker_id"], name: "index_motor_insurances_on_broker_id"
    t.index ["created_at"], name: "idx_motor_insurances_created_at"
    t.index ["customer_id"], name: "index_motor_insurances_on_customer_id"
    t.index ["distributor_id"], name: "index_motor_insurances_on_distributor_id"
    t.index ["investor_id"], name: "index_motor_insurances_on_investor_id"
    t.index ["lead_id"], name: "index_motor_insurances_on_lead_id", unique: true
    t.index ["policy_number"], name: "index_motor_insurances_on_policy_number", unique: true
    t.index ["sub_agent_id"], name: "index_motor_insurances_on_sub_agent_id"
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
    t.date "policy_end_date"
    t.date "policy_start_date"
    t.date "policy_booking_date"
    t.boolean "product_through_dr", default: false
    t.boolean "main_agent_commission_received", default: false
    t.string "main_agent_commission_transaction_id"
    t.date "main_agent_commission_paid_date"
    t.text "main_agent_commission_notes"
    t.bigint "distributor_id"
    t.string "lead_id"
    t.bigint "investor_id"
    t.index ["created_at"], name: "idx_other_insurances_created_at"
    t.index ["distributor_id"], name: "index_other_insurances_on_distributor_id"
    t.index ["investor_id"], name: "index_other_insurances_on_investor_id"
    t.index ["lead_id"], name: "index_other_insurances_on_lead_id", unique: true
    t.index ["policy_id"], name: "index_other_insurances_on_policy_id"
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
    t.index ["affiliate_commission_id"], name: "index_payouts_on_affiliate_commission_id"
    t.index ["ambassador_commission_id"], name: "index_payouts_on_ambassador_commission_id"
    t.index ["company_expense_commission_id"], name: "index_payouts_on_company_expense_commission_id"
    t.index ["investor_commission_id"], name: "index_payouts_on_investor_commission_id"
    t.index ["main_agent_commission_id"], name: "index_payouts_on_main_agent_commission_id"
    t.index ["policy_type", "policy_id"], name: "idx_payouts_policy"
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
    t.index ["agency_broker_id"], name: "index_policies_on_agency_broker_id"
    t.index ["customer_id", "created_at"], name: "index_policies_on_customer_id_and_created_at"
    t.index ["customer_id"], name: "index_policies_on_customer_id"
    t.index ["insurance_company_id"], name: "index_policies_on_insurance_company_id"
    t.index ["user_id"], name: "index_policies_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "category_type", null: false
    t.bigint "parent_id"
    t.boolean "is_active", default: true
    t.string "image_url"
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_type"], name: "index_product_categories_on_category_type"
    t.index ["is_active"], name: "index_product_categories_on_is_active"
    t.index ["parent_id", "name"], name: "index_product_categories_on_parent_id_and_name", unique: true
    t.index ["parent_id"], name: "index_product_categories_on_parent_id"
  end

  create_table "product_locations", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "location", null: false
    t.boolean "is_available", default: true
    t.text "availability_notes"
    t.decimal "location_specific_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_available"], name: "index_product_locations_on_is_available"
    t.index ["product_id", "location"], name: "index_product_locations_on_product_id_and_location", unique: true
    t.index ["product_id"], name: "index_product_locations_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "product_type", null: false
    t.string "sku"
    t.decimal "price", precision: 10, scale: 2
    t.string "status", default: "active"
    t.bigint "product_category_id", null: false
    t.string "insurance_company"
    t.string "plan_name"
    t.integer "min_age"
    t.integer "max_age"
    t.decimal "min_sum_insured", precision: 12, scale: 2
    t.decimal "max_sum_insured", precision: 12, scale: 2
    t.json "features"
    t.json "benefits"
    t.string "meta_title"
    t.text "meta_description"
    t.string "slug"
    t.boolean "featured", default: false
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["product_type"], name: "index_products_on_product_type"
    t.index ["sku"], name: "index_products_on_sku", unique: true, where: "(sku IS NOT NULL)"
    t.index ["slug"], name: "index_products_on_slug", unique: true, where: "(slug IS NOT NULL)"
    t.index ["status"], name: "index_products_on_status"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "idx_role_permissions_permission"
    t.index ["role_id", "permission_id"], name: "idx_role_permissions_unique", unique: true
    t.index ["role_id"], name: "idx_role_permissions_role"
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
    t.string "password_digest"
    t.bigint "distributor_id"
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
    t.boolean "admin", default: false
    t.string "original_password"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "idx_users_role_id"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agency_codes", "brokers"
  add_foreign_key "brokers", "insurance_companies"
  add_foreign_key "client_requests", "users", column: "resolved_by_id"
  add_foreign_key "commission_payouts", "payouts"
  add_foreign_key "corporate_members", "customers"
  add_foreign_key "customers", "sub_agents"
  add_foreign_key "distributor_assignments", "distributors"
  add_foreign_key "distributor_assignments", "sub_agents"
  add_foreign_key "distributor_documents", "distributors"
  add_foreign_key "distributor_payouts", "distributors"
  add_foreign_key "family_members", "customers"
  add_foreign_key "health_insurance_members", "health_insurances"
  add_foreign_key "health_insurances", "agency_codes"
  add_foreign_key "health_insurances", "brokers"
  add_foreign_key "health_insurances", "customers"
  add_foreign_key "health_insurances", "distributors"
  add_foreign_key "health_insurances", "investors"
  add_foreign_key "health_insurances", "policies"
  add_foreign_key "health_insurances", "sub_agents"
  add_foreign_key "investments", "customers"
  add_foreign_key "investor_documents", "investors"
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
  add_foreign_key "motor_insurances", "agency_codes"
  add_foreign_key "motor_insurances", "brokers"
  add_foreign_key "motor_insurances", "customers"
  add_foreign_key "motor_insurances", "distributors"
  add_foreign_key "motor_insurances", "investors"
  add_foreign_key "motor_insurances", "sub_agents"
  add_foreign_key "other_insurances", "distributors"
  add_foreign_key "other_insurances", "investors"
  add_foreign_key "other_insurances", "policies"
  add_foreign_key "payout_distributions", "commission_receipts"
  add_foreign_key "policies", "agency_brokers"
  add_foreign_key "policies", "customers"
  add_foreign_key "policies", "insurance_companies"
  add_foreign_key "policies", "users"
  add_foreign_key "product_categories", "product_categories", column: "parent_id"
  add_foreign_key "product_locations", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "sub_agent_documents", "sub_agents"
  add_foreign_key "sub_agents", "distributors"
  add_foreign_key "tax_services", "customers"
  add_foreign_key "travel_packages", "customers"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "user_roles"
end
