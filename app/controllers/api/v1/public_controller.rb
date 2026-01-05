class Api::V1::PublicController < ActionController::Base
  # CORS headers for cross-origin requests
  before_action :set_cors_headers

  def search_sub_agents
    begin
      query = params[:q] || params[:query]
      limit = params[:limit]&.to_i || 20
      affiliates = []

      Rails.logger.info "Public search sub agents called with query: '#{query}', limit: #{limit}"

      if query.present? && query.strip.length >= 2
        # Search with query
        affiliates = SubAgent.active
                            .where("LOWER(first_name || ' ' || last_name) ILIKE ?", "%#{query.downcase}%")
                            .limit(limit)
                            .map { |agent| { id: agent.id, text: agent.display_name } }
        Rails.logger.info "Search found #{affiliates.count} sub agents matching '#{query}'"
      else
        # Return default affiliates when no search query (show recently active or all)
        affiliates = SubAgent.active
                            .order(:first_name, :last_name)
                            .limit([limit, 10].min) # Show max 10 when no search
                            .map { |agent| { id: agent.id, text: agent.display_name } }
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

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept'
  end
end