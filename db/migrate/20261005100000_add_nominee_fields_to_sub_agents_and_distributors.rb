class AddNomineeFieldsToSubAgentsAndDistributors < ActiveRecord::Migration[8.0]
  def change
    %i[sub_agents distributors].each do |table|
      add_column table, :nominee_name, :string
      add_column table, :nominee_relation, :string
      add_column table, :nominee_date_of_birth, :date
      add_column table, :nominee_mobile, :string
    end
  end
end
