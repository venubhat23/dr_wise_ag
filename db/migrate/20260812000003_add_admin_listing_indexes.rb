class AddAdminListingIndexes < ActiveRecord::Migration[8.0]
  def change
    # investors has no indexes at all — status filter and name sort/search
    # on the admin listing page do a full table scan + sort every request.
    unless index_exists?(:investors, :status)
      add_index :investors, :status
    end
    unless index_exists?(:investors, [:first_name, :last_name])
      add_index :investors, [:first_name, :last_name]
    end

    # insurance_companies has no indexes at all — admin listing filters by
    # insurance_type/status and always sorts by name.
    unless index_exists?(:insurance_companies, :name)
      add_index :insurance_companies, :name
    end
    unless index_exists?(:insurance_companies, :insurance_type)
      add_index :insurance_companies, :insurance_type
    end
    unless index_exists?(:insurance_companies, :status)
      add_index :insurance_companies, :status
    end

    # banners: status/current filters used on admin listing stat cards
    unless index_exists?(:banners, :status)
      add_index :banners, :status
    end
    unless index_exists?(:banners, [:display_start_date, :display_end_date])
      add_index :banners, [:display_start_date, :display_end_date]
    end
  end
end
