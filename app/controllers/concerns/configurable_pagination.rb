module ConfigurablePagination
  extend ActiveSupport::Concern

  private

  def default_per_page
    SystemSetting.default_pagination_per_page
  end

  def per_page_param
    # Allow users to override via URL parameter, but limit to reasonable bounds
    per_page = params[:per_page].to_i
    return default_per_page if per_page <= 0

    # Limit between 5 and 100, default to system setting if out of bounds
    [[per_page, 5].max, 100].min
  end

  def paginate_records(records, total_count = nil)
    per_page = per_page_param
    records = apply_column_sort(records)

    # Use provided total_count or calculate it safely
    total_count ||= begin
      records.count
    rescue PG::UndefinedFunction
      # If count fails due to select() with multiple columns, use size
      records.size
    end

    # Store total count and per_page for view access
    @total_record_count = total_count
    @items_per_page = per_page
    @show_pagination = total_count > per_page

    # Only apply pagination if needed
    paginated = if @show_pagination
      records.page(params[:page]).per(per_page)
    else
      # Return all records without pagination if count is less than or equal to items per page
      records.page(1).per(total_count > 0 ? total_count : 1)
    end

    # We already know the total count above — hand it to Kaminari so views
    # calling `paginated.total_count` / `total_pages` (e.g. via the `paginate`
    # helper or the shared pagination partial) don't re-run the same COUNT query.
    paginated.instance_variable_set(:@total_count, total_count) if paginated.respond_to?(:total_count)

    # Force-load now so `.any?` (checked before `.each` in every index view) reads
    # from the already-loaded records instead of firing its own EXISTS query.
    paginated.load
  end

  # Click-to-sort across ALL records (not just the visible page): table_sort.js
  # sends ?sort=<column>&direction=asc|desc. Only real columns of the listed
  # model's own table are accepted; anything else is ignored. The accepted
  # columns are exposed to the page (layout meta tag) so the JS knows which
  # headers can be sorted server-side.
  def apply_column_sort(records)
    return records unless records.respond_to?(:reorder) && records.respond_to?(:klass)
    # GROUP BY / DISTINCT-with-custom-select queries can't take an arbitrary ORDER BY.
    return records if records.group_values.present? || (records.distinct_value && records.select_values.present?)

    klass = records.klass
    @server_sort_columns = klass.column_names - %w[encrypted_password password_digest original_password
                                                 reset_password_token confirmation_token]
    column = params[:sort].to_s
    return records unless @server_sort_columns.include?(column)

    direction = params[:direction].to_s.downcase == 'desc' ? 'DESC' : 'ASC'
    @current_sort = { column: column, direction: direction.downcase }
    quoted = "#{klass.connection.quote_table_name(klass.table_name)}.#{klass.connection.quote_column_name(column)}"
    records.reorder(Arel.sql("#{quoted} #{direction} NULLS LAST"), klass.arel_table[klass.primary_key].desc)
  rescue StandardError => e
    Rails.logger.warn "Column sort skipped (#{params[:sort]}): #{e.message}"
    records
  end

  # Helper method to check if pagination should be shown
  def should_show_pagination?(records = nil)
    if records
      total = records.respond_to?(:total_count) ? records.total_count : records.count
      total > per_page_param
    else
      @show_pagination
    end
  end
end