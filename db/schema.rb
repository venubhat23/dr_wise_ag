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

ActiveRecord::Schema[8.0].define(version: 2026_01_15_103728) do
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
