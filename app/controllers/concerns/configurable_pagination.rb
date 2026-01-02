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

  def paginate_records(records)
    per_page = per_page_param
    records.page(params[:page]).per(per_page)
  end
end