class AddPolicyDateIndexes < ActiveRecord::Migration[8.0]
  def change
    # policy_start_date/policy_booking_date are the primary filter columns for
    # dashboard aggregates (premium, sum insured, profit) but were unindexed —
    # only policy_end_date had an index.
    %i[health_insurances life_insurances motor_insurances other_insurances].each do |table|
      unless index_exists?(table, :policy_start_date)
        add_index table, :policy_start_date, name: "index_#{table}_on_policy_start_date"
      end
    end

    %i[health_insurances life_insurances motor_insurances].each do |table|
      unless index_exists?(table, :policy_booking_date)
        add_index table, :policy_booking_date, name: "index_#{table}_on_policy_booking_date"
      end
    end
  end
end
