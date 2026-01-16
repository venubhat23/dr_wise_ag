class AddMissingColumnsToPolicy < ActiveRecord::Migration[8.0]
  def change
    add_column :policies, :insurance_type, :string, default: 'life' unless column_exists?(:policies, :insurance_type)
    add_column :policies, :payment_mode, :string, default: 'yearly' unless column_exists?(:policies, :payment_mode)
    add_column :policies, :policy_start_date, :date unless column_exists?(:policies, :policy_start_date)
    add_column :policies, :policy_end_date, :date unless column_exists?(:policies, :policy_end_date)
    add_column :policies, :sum_insured, :decimal, precision: 12, scale: 2, default: 0.0 unless column_exists?(:policies, :sum_insured)
    add_column :policies, :net_premium, :decimal, precision: 10, scale: 2, default: 0.0 unless column_exists?(:policies, :net_premium)
    add_column :policies, :total_premium, :decimal, precision: 10, scale: 2, default: 0.0 unless column_exists?(:policies, :total_premium)
    add_column :policies, :status, :boolean, default: true unless column_exists?(:policies, :status)
    add_column :policies, :plan_name, :string unless column_exists?(:policies, :plan_name)
    add_column :policies, :gst_percentage, :decimal, precision: 5, scale: 2, default: 18.0 unless column_exists?(:policies, :gst_percentage)

    # Add missing association columns
    add_column :policies, :user_id, :integer unless column_exists?(:policies, :user_id)
    add_column :policies, :insurance_company_id, :integer unless column_exists?(:policies, :insurance_company_id)
    add_column :policies, :agency_broker_id, :integer unless column_exists?(:policies, :agency_broker_id)

    # Update existing records with default values
    execute <<-SQL
      UPDATE policies SET
        insurance_type = 'life',
        payment_mode = 'yearly',
        policy_start_date = created_at::date,
        policy_end_date = (created_at + INTERVAL '1 year')::date,
        sum_insured = 100000.0,
        net_premium = 5000.0,
        total_premium = 5900.0,
        status = true,
        plan_name = 'Default Plan',
        gst_percentage = 18.0,
        user_id = 1,
        insurance_company_id = 1,
        agency_broker_id = 1
      WHERE insurance_type IS NULL;
    SQL

    # Add indexes for performance
    add_index :policies, :insurance_type unless index_exists?(:policies, :insurance_type)
    add_index :policies, :policy_start_date unless index_exists?(:policies, :policy_start_date)
    add_index :policies, :policy_end_date unless index_exists?(:policies, :policy_end_date)
    add_index :policies, :status unless index_exists?(:policies, :status)
  end
end
