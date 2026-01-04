# Alias controller for SubAgentsController using new terminology
class Admin::AffiliatesController < Admin::SubAgentsController
  # This controller inherits all functionality from SubAgentsController
  # but provides the new naming convention for consistency

  private

  # Override model references to use Affiliate
  def model_class
    Affiliate
  end

  # Override breadcrumb and page titles if needed
  def set_page_title
    @page_title = "Affiliates"
  end
end