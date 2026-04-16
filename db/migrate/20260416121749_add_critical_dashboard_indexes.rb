class AddCriticalDashboardIndexes < ActiveRecord::Migration[8.0]
  def change
    # Critical indexes for product_through_dr filtering
    add_index :health_insurances, :product_through_dr unless index_exists?(:health_insurances, :product_through_dr)
    add_index :life_insurances, :product_through_dr unless index_exists?(:life_insurances, :product_through_dr)

    if table_exists?(:motor_insurances)
      add_index :motor_insurances, :product_through_dr unless index_exists?(:motor_insurances, :product_through_dr)
    end

    if table_exists?(:other_insurances)
      add_index :other_insurances, :product_through_dr unless index_exists?(:other_insurances, :product_through_dr)
    end

    # Composite indexes for most common dashboard queries
    add_index :health_insurances, [:product_through_dr, :created_at] unless index_exists?(:health_insurances, [:product_through_dr, :created_at])
    add_index :life_insurances, [:product_through_dr, :created_at] unless index_exists?(:life_insurances, [:product_through_dr, :created_at])

    if table_exists?(:motor_insurances)
      add_index :motor_insurances, [:product_through_dr, :created_at] unless index_exists?(:motor_insurances, [:product_through_dr, :created_at])
    end

    # Critical indexes for affiliate calculation
    add_index :health_insurances, :sub_agent_id unless index_exists?(:health_insurances, :sub_agent_id)
    add_index :life_insurances, :sub_agent_id unless index_exists?(:life_insurances, :sub_agent_id)

    if table_exists?(:motor_insurances)
      add_index :motor_insurances, :sub_agent_id unless index_exists?(:motor_insurances, :sub_agent_id)
    end

    # Indexes for premium calculations
    add_index :health_insurances, [:product_through_dr, :total_premium] unless index_exists?(:health_insurances, [:product_through_dr, :total_premium])
    add_index :life_insurances, [:product_through_dr, :total_premium] unless index_exists?(:life_insurances, [:product_through_dr, :total_premium])

    if table_exists?(:motor_insurances)
      add_index :motor_insurances, [:product_through_dr, :total_premium] unless index_exists?(:motor_insurances, [:product_through_dr, :total_premium])
    end

    # Index for sum_insured calculations
    add_index :health_insurances, [:product_through_dr, :sum_insured] unless index_exists?(:health_insurances, [:product_through_dr, :sum_insured])
    add_index :life_insurances, [:product_through_dr, :sum_insured] unless index_exists?(:life_insurances, [:product_through_dr, :sum_insured])

    if table_exists?(:motor_insurances)
      add_index :motor_insurances, [:product_through_dr, :sum_insured] unless index_exists?(:motor_insurances, [:product_through_dr, :sum_insured])
    end
  end
end
