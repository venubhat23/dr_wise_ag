class AddAdminReportsIndexes < ActiveRecord::Migration[8.0]
  def change
    # /admin/agency_codes filters and stats-cards query by insurance_type and
    # company_name on every request - neither had an index.
    unless index_exists?(:agency_codes, :insurance_type)
      add_index :agency_codes, :insurance_type
    end
    unless index_exists?(:agency_codes, :company_name)
      add_index :agency_codes, :company_name
    end

    # /admin/invoices always sorts by created_at - no index existed.
    unless index_exists?(:invoices, :created_at)
      add_index :invoices, :created_at
    end
  end
end
