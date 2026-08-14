class AddReportsCreatedByIndex < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    # reports: created_by_id lookups (belongs_to :created_by) had no index
    unless index_exists?(:reports, :created_by_id)
      add_index :reports, :created_by_id, algorithm: :concurrently
    end
  end
end
