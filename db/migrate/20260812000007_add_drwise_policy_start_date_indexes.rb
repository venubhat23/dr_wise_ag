class AddDrwisePolicyStartDateIndexes < ActiveRecord::Migration[8.0]
  def change
    # Admin::AnalyticsController and DashboardController both filter every
    # insurance query on (is_admin_added, is_customer_added, is_agent_added)
    # together with a policy_start_date range. Each table already has a
    # DRWISE index and a separate policy_start_date index, which Postgres
    # combines with a bitmap AND — a single composite index lets it do a
    # direct range scan instead.
    %i[health_insurances life_insurances motor_insurances other_insurances].each do |table|
      index_name = "idx_#{table}_drwise_policy_start_date"
      next if index_exists?(table, [:is_admin_added, :is_customer_added, :is_agent_added, :policy_start_date], name: index_name)

      add_index table, [:is_admin_added, :is_customer_added, :is_agent_added, :policy_start_date], name: index_name
    end
  end
end
