class AddReportsQueryIndexes < ActiveRecord::Migration[8.0]
  def change
    # leads.created_date (distinct from created_at) is the primary filter/sort
    # column for the Lead Reports page but had no index — full seq scan + sort
    # on every request.
    unless index_exists?(:leads, :created_date)
      add_index :leads, :created_date
    end

    # reports.report_type is filtered on repeatedly (4x per request) by every
    # report controller's "saved reports" listing/stats section but had no index.
    unless index_exists?(:reports, :report_type)
      add_index :reports, :report_type
    end
  end
end
