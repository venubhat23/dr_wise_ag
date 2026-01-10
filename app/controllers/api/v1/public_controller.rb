class Api::V1::PublicController < ActionController::Base
  # CORS headers for cross-origin requests
  before_action :set_cors_headers

  def search_sub_agents
    begin
      query = params[:q] || params[:query]
      customer_id = params[:customer_id]
      limit = params[:limit]&.to_i || 20
      affiliates = []

      Rails.logger.info "Public search sub agents called with query: '#{query}', customer_id: #{customer_id}, limit: #{limit}"

      # Start with active sub agents
      sub_agents_scope = SubAgent.active

      # If customer_id is provided, filter to show only the linked affiliate
      if customer_id.present?
        customer = Customer.find_by(id: customer_id)
        if customer&.affiliate
          # Customer has a linked affiliate, only show that one
          Rails.logger.info "Customer #{customer_id} is linked to affiliate #{customer.affiliate.id} (#{customer.affiliate.display_name})"

          if query.present? && query.strip.length >= 2
            # Apply search filter on the linked affiliate
            if customer.affiliate.display_name.downcase.include?(query.downcase)
              affiliates = [{
                id: customer.affiliate.id,
                text: customer.affiliate.display_name,
                commission_earned: 0,
                customers_count: 0,
                policies_count: 0
              }]
            else
              affiliates = []
            end
          else
            # Just return the linked affiliate
            affiliates = [{
              id: customer.affiliate.id,
              text: customer.affiliate.display_name,
              commission_earned: 0,
              customers_count: 0,
              policies_count: 0
            }]
          end

          Rails.logger.info "Filtered to customer's linked affiliate: #{affiliates}"
          render json: { results: affiliates }
          return
        else
          Rails.logger.info "Customer #{customer_id} has no linked affiliate, showing all affiliates"
        end
      end

      # If no customer filter or customer has no linked affiliate, show all (original behavior)
      if query.present? && query.strip.length >= 2
        # Search with query
        affiliates = sub_agents_scope
                            .where("LOWER(first_name || ' ' || last_name) ILIKE ?", "%#{query.downcase}%")
                            .limit(limit)
                            .map { |agent| {
                              id: agent.id,
                              text: agent.display_name,
                              commission_earned: 0,
                              customers_count: 0,
                              policies_count: 0
                            } }
        Rails.logger.info "Search found #{affiliates.count} sub agents matching '#{query}'"
      else
        # Return default affiliates when no search query (show recently active or all)
        affiliates = sub_agents_scope
                            .order(:first_name, :last_name)
                            .limit([limit, 10].min) # Show max 10 when no search
                            .map { |agent| {
                              id: agent.id,
                              text: agent.display_name,
                              commission_earned: 0,
                              customers_count: 0,
                              policies_count: 0
                            } }
        Rails.logger.info "Returning #{affiliates.count} default sub agents"
      end

      Rails.logger.info "Returning sub agents: #{affiliates}"
      render json: { results: affiliates }
    rescue => e
      Rails.logger.error "Error in public search_sub_agents: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: {
        results: [],
        error: "Failed to load affiliates: #{e.message}"
      }, status: 500
    end
  end

  def search_distributors
    begin
      query = params[:q] || params[:query]
      limit = params[:limit]&.to_i || 20
      distributors = []

      Rails.logger.info "Public search distributors called with query: '#{query}', limit: #{limit}"

      # Start with active distributors
      distributors_scope = Distributor.active

      if query.present? && query.strip.length >= 2
        # Search with query
        distributors = distributors_scope
                              .where("LOWER(first_name || ' ' || last_name) ILIKE ?", "%#{query.downcase}%")
                              .limit(limit)
                              .map { |distributor| {
                                id: distributor.id,
                                text: distributor.display_name,
                                commission_earned: 0,
                                customers_count: 0,
                                policies_count: 0
                              } }
        Rails.logger.info "Search found #{distributors.count} distributors matching '#{query}'"
      else
        # Return default distributors when no search query
        distributors = distributors_scope
                              .order(:first_name, :last_name)
                              .limit([limit, 10].min)
                              .map { |distributor| {
                                id: distributor.id,
                                text: distributor.display_name,
                                commission_earned: 0,
                                customers_count: 0,
                                policies_count: 0
                              } }
        Rails.logger.info "Returning #{distributors.count} default distributors"
      end

      Rails.logger.info "Returning distributors: #{distributors}"
      render json: { results: distributors }
    rescue => e
      Rails.logger.error "Error in public search_distributors: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: {
        results: [],
        error: "Failed to load distributors: #{e.message}"
      }, status: 500
    end
  end

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept'
  end
end