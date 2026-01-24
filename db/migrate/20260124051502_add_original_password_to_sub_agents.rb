class AddOriginalPasswordToSubAgents < ActiveRecord::Migration[8.0]
  def change
    add_column :sub_agents, :original_password, :string
  end
end
