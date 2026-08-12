class AddClientServicesIndexes < ActiveRecord::Migration[8.0]
  def change
    # /admin/client_services filters on status and is_admin_added (6 separate
    # queries per request in #calculate_statistics) and always sorts by
    # created_at - none of these had an index.
    unless index_exists?(:client_services, :status)
      add_index :client_services, :status
    end
    unless index_exists?(:client_services, :is_admin_added)
      add_index :client_services, :is_admin_added
    end
    unless index_exists?(:client_services, :created_at)
      add_index :client_services, :created_at
    end
  end
end
