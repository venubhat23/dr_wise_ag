class Api::V1::Mobile::SubAgentController < Api::V1::Mobile::BaseController
  before_action :authenticate_sub_agent!

  # GET /api/v1/mobile/sub_agent/leads
  # Get leads submitted by the current sub_agent
  def leads
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    status_filter = params[:status]
    search = params[:search]

    # Get leads created by this sub_agent
    leads = Lead.where(affiliate_id: current_sub_agent.id)

    # Apply filters
    if status_filter.present?
      leads = leads.where(current_stage: status_filter)
    end

    if search.present?
      leads = leads.where("name ILIKE ? OR contact_number ILIKE ? OR email ILIKE ? OR lead_id ILIKE ?",
                         "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    end

    # Order and paginate
    leads = leads.order(created_at: :desc)
                 .page(page)
                 .per(per_page)

    render json: {
      success: true,
      data: {
        leads: leads.map do |lead|
          {
            id: lead.id,
            lead_id: lead.lead_id,
            name: lead.name,
            first_name: lead.first_name,
            last_name: lead.last_name,
            contact_number: lead.contact_number,
            email: lead.email,
            status: lead.current_stage,
            lead_source: lead.lead_source,
            product_category: lead.product_category,
            product_subcategory: lead.product_subcategory,
            customer_type: lead.customer_type,
            created_date: lead.created_date,
            stage_updated_at: lead.stage_updated_at,
            notes: lead.notes,
            is_converted: lead.converted_customer_id.present?,
            converted_customer_id: lead.converted_customer_id,
            follow_up_date: lead.follow_up_date,
            follow_up_time: lead.follow_up_time,
            address: lead.address,
            city: lead.city,
            state: lead.state,
            pincode: lead.pincode
          }
        end,
        pagination: {
          current_page: leads.current_page,
          total_pages: leads.total_pages,
          total_count: leads.total_count,
          per_page: per_page.to_i
        }
      }
    }
  end

  # GET /api/v1/mobile/sub_agent/leads/:id
  # Get specific lead details submitted by the sub_agent
  def lead_details
    lead = Lead.find_by(id: params[:id], affiliate_id: current_sub_agent.id)

    if lead.nil?
      return render json: {
        success: false,
        message: 'Lead not found or you do not have access to this lead'
      }, status: :not_found
    end

    render json: {
      success: true,
      data: {
        lead: {
          id: lead.id,
          lead_id: lead.lead_id,
          name: lead.name,
          first_name: lead.first_name,
          middle_name: lead.middle_name,
          last_name: lead.last_name,
          contact_number: lead.contact_number,
          alternate_contact_number: lead.alternate_contact_number,
          email: lead.email,
          status: lead.current_stage,
          lead_source: lead.lead_source,
          product_category: lead.product_category,
          product_subcategory: lead.product_subcategory,
          customer_type: lead.customer_type,
          company_name: lead.company_name,
          gender: lead.gender,
          date_of_birth: lead.date_of_birth,
          marital_status: lead.marital_status,
          occupation: lead.occupation,
          annual_income: lead.annual_income,
          business_job: lead.business_job,
          pan_no: lead.pan_no,
          gst_no: lead.gst_no,
          address: lead.address,
          city: lead.city,
          state: lead.state,
          pincode: lead.pincode,
          created_date: lead.created_date,
          stage_updated_at: lead.stage_updated_at,
          notes: lead.notes,
          is_converted: lead.converted_customer_id.present?,
          converted_customer_id: lead.converted_customer_id,
          converted_customer_name: lead.converted_customer&.display_name,
          follow_up_date: lead.follow_up_date,
          follow_up_time: lead.follow_up_time,
          height: lead.height,
          weight: lead.weight,
          disease_details: lead.disease_details,
          medicine_details: lead.medicine_details,
          doctor_details: lead.doctor_details,
          smoke_habbit: lead.smoke_habbit,
          alcohol_habbit: lead.alcohol_habbit,
          existing_policy_details: lead.existing_policy_details,
          branch_out_leads: lead.branch_out_leads.map { |bl| { id: bl.id, lead_id: bl.lead_id, name: bl.name } }
        }
      }
    }
  end

  # POST /api/v1/mobile/sub_agent/helpdesk
  # Create a new helpdesk ticket
  def create_helpdesk_ticket
    ticket_params = params.permit(:subject, :description, :category, :priority)

    # Validate required fields
    if ticket_params[:subject].blank? || ticket_params[:description].blank?
      return render json: {
        success: false,
        message: 'Subject and description are required'
      }, status: :unprocessable_entity
    end

    begin
      # Create client request (helpdesk ticket)
      ticket = ClientRequest.create!(
        name: current_sub_agent.full_name,
        email: current_sub_agent.email,
        phone_number: current_sub_agent.mobile,
        subject: ticket_params[:subject],
        description: ticket_params[:description],
        category: ticket_params[:category] || 'general',
        priority: ticket_params[:priority] || 'medium',
        status: 'pending',
        submitter_type: 'SubAgent',
        submitter_id: current_sub_agent.id
      )

      render json: {
        success: true,
        message: 'Helpdesk ticket created successfully',
        data: {
          ticket: {
            id: ticket.id,
            ticket_number: ticket.ticket_number || "TKT#{ticket.id.to_s.rjust(6, '0')}",
            subject: ticket.subject,
            description: ticket.description,
            category: ticket.category,
            priority: ticket.priority,
            status: ticket.status,
            created_at: ticket.created_at
          }
        }
      }
    rescue => e
      render json: {
        success: false,
        message: 'Failed to create helpdesk ticket',
        errors: [e.message]
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/mobile/sub_agent/helpdesk_tickets
  # Get helpdesk tickets created by the sub_agent
  def helpdesk_tickets
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    status_filter = params[:status]

    tickets = ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id)

    if status_filter.present?
      tickets = tickets.where(status: status_filter)
    end

    tickets = tickets.order(created_at: :desc)
                    .page(page)
                    .per(per_page)

    render json: {
      success: true,
      data: {
        tickets: tickets.map do |ticket|
          {
            id: ticket.id,
            ticket_number: ticket.ticket_number || "TKT#{ticket.id.to_s.rjust(6, '0')}",
            subject: ticket.subject,
            description: ticket.description,
            category: ticket.category,
            priority: ticket.priority,
            status: ticket.status,
            resolution_notes: ticket.resolution_notes,
            resolved_at: ticket.resolved_at,
            created_at: ticket.created_at,
            updated_at: ticket.updated_at
          }
        end,
        pagination: {
          current_page: tickets.current_page,
          total_pages: tickets.total_pages,
          total_count: tickets.total_count,
          per_page: per_page.to_i
        }
      }
    }
  end

  private

  def authenticate_sub_agent!
    unless current_sub_agent
      render json: {
        success: false,
        message: 'Authentication required. Please login as a sub-agent.'
      }, status: :unauthorized
    end
  end

  def current_sub_agent
    @current_sub_agent ||= begin
      token = request.headers['Authorization']&.split(' ')&.last
      return nil unless token

      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      user_id = decoded[0]['user_id']
      user_type = decoded[0]['user_type']

      if user_type == 'sub_agent'
        SubAgent.find_by(id: user_id)
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end