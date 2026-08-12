class AddMorePerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # client_services: distributor_id used for distributor commission lookups/filters
    unless index_exists?(:client_services, :distributor_id)
      add_index :client_services, :distributor_id, name: 'index_client_services_on_distributor_id'
    end

    # health_insurances/other_insurances: original_policy_id has an FK constraint
    # (self-referencing, used for renewal chains) but no supporting index
    unless index_exists?(:health_insurances, :original_policy_id)
      add_index :health_insurances, :original_policy_id, name: 'index_health_insurances_on_original_policy_id'
    end
    unless index_exists?(:other_insurances, :original_policy_id)
      add_index :other_insurances, :original_policy_id, name: 'index_other_insurances_on_original_policy_id'
    end
  end
end
