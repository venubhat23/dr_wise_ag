# Alias controller for DistributorsController using new terminology
class Admin::AmbassadorsController < Admin::DistributorsController
  # This controller inherits all functionality from DistributorsController
  # but provides the new naming convention for consistency

  private

  # Override model references to use Ambassador
  def model_class
    Ambassador
  end

  # Override breadcrumb and page titles if needed
  def set_page_title
    @page_title = "Ambassadors"
  end
end