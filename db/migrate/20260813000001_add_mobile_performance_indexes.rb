class AddMobilePerformanceIndexes < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    # distributors: state_id/city_id used for location filters, no index existed
    unless index_exists?(:distributors, :state_id)
      add_index :distributors, :state_id, algorithm: :concurrently
    end
    unless index_exists?(:distributors, :city_id)
      add_index :distributors, :city_id, algorithm: :concurrently
    end

    # all_policy_reports: created_by_id lookups had no index
    unless index_exists?(:all_policy_reports, :created_by_id)
      add_index :all_policy_reports, :created_by_id, algorithm: :concurrently
    end

    # helpdesk_tickets: submitter_id lookups had no index
    unless index_exists?(:helpdesk_tickets, :submitter_id)
      add_index :helpdesk_tickets, :submitter_id, algorithm: :concurrently
    end

    # invoice_items: polymorphic (payout_type, payout_id) pair had no composite
    # index, unlike the equivalent columns on invoices itself
    unless index_exists?(:invoice_items, %i[payout_type payout_id])
      add_index :invoice_items, %i[payout_type payout_id], algorithm: :concurrently
    end

    # other_insurances: agency_code_id/broker_id missing, even though the
    # equivalent columns on health/life/motor_insurances already have indexes
    unless index_exists?(:other_insurances, :agency_code_id)
      add_index :other_insurances, :agency_code_id, algorithm: :concurrently
    end
    unless index_exists?(:other_insurances, :broker_id)
      add_index :other_insurances, :broker_id, algorithm: :concurrently
    end

    # payouts: idx_payouts_policy and index_payouts_on_policy_type_and_id are
    # identical duplicate indexes on [policy_type, policy_id] - drop one
    if index_name_exists?(:payouts, 'idx_payouts_policy')
      remove_index :payouts, name: 'idx_payouts_policy', algorithm: :concurrently
    end
  end
end
