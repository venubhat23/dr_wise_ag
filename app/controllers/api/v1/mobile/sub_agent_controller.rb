class Api::V1::Mobile::SubAgentController < Api::V1::Mobile::BaseController
  before_action :authenticate_customer!
  before_action :validate_sub_agent_access

  # GET /api/v1/mobile/sub_agent/leads
  # Get leads submitted by the current sub_agent with comprehensive information
  def leads
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    status_filter = params[:status]
    product_filter = params[:product_category]
    search = params[:search]

    # Get leads created by this sub_agent with includes for better performance
    leads = Lead.includes(:converted_customer, :created_policy, :affiliate, :ambassador)
                .where(affiliate_id: current_sub_agent.id)

    # Apply filters
    if status_filter.present?
      leads = leads.where(current_stage: status_filter)
    end

    if product_filter.present?
      leads = leads.where(product_category: product_filter)
    end

    if search.present?
      leads = leads.where("name ILIKE ? OR contact_number ILIKE ? OR email ILIKE ? OR lead_id ILIKE ?",
                         "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    end

    # Get total count before pagination
    total_count = leads.count

    # Order and paginate
    page = page.to_i
    per_page = per_page.to_i
    per_page = [per_page, 50].min # Limit to max 50 records per page
    offset = (page - 1) * per_page

    leads = leads.order(created_at: :desc)
                 .limit(per_page)
                 .offset(offset)

    render json: {
      success: true,
      data: {
        leads: leads.map do |lead|
          begin
            {
              id: lead.id,
              lead_id: lead.lead_id,
              name: lead.name,
              display_name: lead.name, # Use name as display_name
              first_name: lead.first_name,
              middle_name: lead.middle_name,
              last_name: lead.last_name,
              company_name: lead.company_name,
              contact_number: lead.contact_number,
              email: lead.email,
              current_stage: lead.current_stage,
              product_category: lead.product_category,
              product_subcategory: lead.product_subcategory,
              product_interest: lead.product_interest,
              lead_source: lead.lead_source,
              customer_type: lead.customer_type,
              referred_by: lead.referred_by,
              referral_amount: lead.referral_amount,
              birth_date: lead.birth_date,
              gender: lead.gender,
              marital_status: lead.marital_status,
              occupation: lead.occupation,
              annual_income: lead.annual_income,
              pan_no: lead.pan_no,
              gst_no: lead.gst_no,
              height: lead.height,
              weight: lead.weight,
              address: lead.address,
              city: lead.city,
              state: lead.state,
              created_date: lead.created_date,
              stage_updated_at: lead.stage_updated_at,
              notes: lead.notes,
              is_converted: lead.converted_customer_id.present?,
              converted_customer_id: lead.converted_customer_id,
              policy_created_id: lead.policy_created_id,
              is_direct: lead.is_direct,
              is_branch_out: lead.is_branch_out,
              affiliate_id: lead.affiliate_id,
              ambassador_id: lead.ambassador_id,
              created_at: lead.created_at,
              updated_at: lead.updated_at,
              # Additional computed fields
              affiliate_name: lead.affiliate_id.present? ? SubAgent.find_by(id: lead.affiliate_id)&.display_name : nil,
              ambassador_name: lead.ambassador_id.present? ? Distributor.find_by(id: lead.ambassador_id)&.display_name : nil,
              formatted_created_date: lead.created_date&.strftime('%d %b, %Y'),
              full_address: [lead.address, lead.city, lead.state].compact.join(', ')
            }
          rescue => e
            Rails.logger.error "Error formatting lead #{lead.id}: #{e.message}"
            {
              id: lead.id,
              lead_id: lead.lead_id,
              name: lead.name,
              contact_number: lead.contact_number,
              email: lead.email,
              current_stage: lead.current_stage,
              error: "Error loading lead details"
            }
          end
            email: lead.email,
            current_stage: lead.current_stage,
            stage_display_name: lead.stage_display_name,
            stage_description: lead.stage_description,
            stage_badge_class: lead.stage_badge_class,
            lead_source: lead.lead_source,
            source_badge_class: lead.source_badge_class,
            product_category: lead.product_category,
            product_subcategory: lead.product_subcategory,
            product_subcategory_display: lead.product_subcategory_display,
            product_badge_class: lead.product_badge_class,
            customer_type: lead.customer_type,
            gender: lead.gender,
            date_of_birth: lead.date_of_birth,
            age: lead.age,
            marital_status: lead.marital_status,
            occupation: lead.occupation,
            annual_income: lead.annual_income,
            business_job: lead.business_job,
            pan_no: lead.pan_no,
            gst_no: lead.gst_no,
            height: lead.height,
            weight: lead.weight,
            formatted_height: lead.formatted_height,
            address: lead.address,
            city: lead.city,
            state: lead.state,
            pincode: lead.pincode,
            full_address: lead.full_address,
            created_date: lead.created_date,
            formatted_created_date: lead.formatted_created_date,
            stage_updated_at: lead.stage_updated_at,
            notes: lead.notes,
            follow_up_date: lead.follow_up_date,
            follow_up_time: lead.follow_up_time,
            is_converted: lead.converted_customer_id.present?,
            converted_customer_id: lead.converted_customer_id,
            converted_customer_name: lead.converted_customer&.display_name,
            policy_created_id: lead.policy_created_id,
            is_direct: lead.is_direct,
            referral_type: lead.referral_type,
            affiliate_name: lead.affiliate_name,
            ambassador_name: lead.ambassador_name,
            stage_progress_percentage: lead.stage_progress_percentage,
            can_advance: lead.can_advance?,
            can_go_back: lead.can_go_back?,
            next_stage: lead.next_stage,
            previous_stage: lead.previous_stage,
            next_stage_options: lead.next_stage_options,
            can_convert_to_customer: lead.can_convert_to_customer?,
            can_create_policy: lead.can_create_policy?,
            locked_stage: lead.locked_stage?,
            is_branch_out: lead.is_branch_out?,
            disease_details: lead.disease_details,
            medicine_details: lead.medicine_details,
            doctor_details: lead.doctor_details,
            smoke_habbit: lead.smoke_habbit,
            alcohol_habbit: lead.alcohol_habbit,
            existing_policy_details: lead.existing_policy_details,
            branch_out_leads: lead.branch_out_leads.map { |bl|
              {
                id: bl.id,
                lead_id: bl.lead_id,
                name: bl.name,
                current_stage: bl.current_stage
              }
            },
            created_at: lead.created_at,
            updated_at: lead.updated_at
          }
        end,
        pagination: {
          current_page: page,
          total_pages: (total_count.to_f / per_page).ceil,
          total_count: total_count,
          per_page: per_page,
          has_next_page: page < (total_count.to_f / per_page).ceil,
          has_prev_page: page > 1
        },
        statistics: {
          total_leads: Lead.where(affiliate_id: current_sub_agent.id).count,
          converted_leads: Lead.where(affiliate_id: current_sub_agent.id, current_stage: 'converted').count,
          pending_leads: Lead.where(affiliate_id: current_sub_agent.id)
                             .where(current_stage: ['consultation_scheduled', 'one_on_one', 'follow_up', 're_follow_up']).count,
          closed_leads: Lead.where(affiliate_id: current_sub_agent.id, current_stage: 'lead_closed').count
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
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 50].min # Limit to max 50 records per page
    status_filter = params[:status]

    tickets = ClientRequest.includes(:resolved_by).where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id)

    if status_filter.present?
      tickets = tickets.where(status: status_filter)
    end

    # Get total count before pagination
    total_count = tickets.count
    offset = (page - 1) * per_page

    tickets = tickets.order(created_at: :desc)
                    .limit(per_page)
                    .offset(offset)

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
            admin_response: ticket.admin_response,
            comments: ticket.admin_response,
            resolved_at: ticket.resolved_at,
            assigned_to: ticket.resolved_by&.full_name || "Unassigned",
            days_since_submission: ticket.days_since_submission,
            created_at: ticket.created_at,
            updated_at: ticket.updated_at
          }
        end,
        pagination: {
          current_page: page,
          total_pages: (total_count.to_f / per_page).ceil,
          total_count: total_count,
          per_page: per_page,
          has_next_page: page < (total_count.to_f / per_page).ceil,
          has_prev_page: page > 1
        },
        summary: {
          total_tickets: ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id).count,
          pending: ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id, status: 'pending').count,
          in_progress: ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id, status: 'in_progress').count,
          resolved: ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id, status: 'resolved').count,
          closed: ClientRequest.where(submitter_type: 'SubAgent', submitter_id: current_sub_agent.id, status: 'closed').count
        }
      }
    }
  end

  # GET /api/v1/mobile/sub_agent/notifications
  # Get notifications for the current sub_agent
  def notifications
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    per_page = [per_page, 50].min # Limit to max 50 records per page
    status_filter = params[:status] # 'read', 'unread', or nil for all

    notifications = Notification.includes(:reference)
                                .for_sub_agent(current_sub_agent.id)

    # Apply status filter
    case status_filter
    when 'read'
      notifications = notifications.read
    when 'unread'
      notifications = notifications.unread
    end

    # Get total count before pagination
    total_count = notifications.count
    offset = (page - 1) * per_page

    notifications = notifications.recent
                                .limit(per_page)
                                .offset(offset)

    render json: {
      success: true,
      data: {
        notifications: notifications.map do |notification|
          {
            id: notification.id,
            notification_type: notification.notification_type,
            title: notification.title,
            message: notification.message,
            is_read: notification.is_read,
            sent_at: notification.sent_at,
            read_at: notification.read_at,
            reference: notification.reference ? {
              type: notification.reference_type,
              id: notification.reference_id,
              details: notification_reference_details(notification.reference)
            } : nil,
            created_at: notification.created_at
          }
        end,
        pagination: {
          current_page: page,
          total_pages: (total_count.to_f / per_page).ceil,
          total_count: total_count,
          per_page: per_page,
          has_next_page: page < (total_count.to_f / per_page).ceil,
          has_prev_page: page > 1
        },
        summary: {
          total_notifications: Notification.for_sub_agent(current_sub_agent.id).count,
          unread_count: Notification.for_sub_agent(current_sub_agent.id).unread.count,
          read_count: Notification.for_sub_agent(current_sub_agent.id).read.count
        }
      }
    }
  end

  # PUT /api/v1/mobile/sub_agent/notifications/:id/mark_read
  # Mark a notification as read
  def mark_notification_read
    notification = Notification.for_sub_agent(current_sub_agent.id).find_by(id: params[:id])

    if notification.nil?
      return render json: {
        success: false,
        message: 'Notification not found or you do not have access to this notification'
      }, status: :not_found
    end

    notification.mark_as_read!

    render json: {
      success: true,
      message: 'Notification marked as read',
      data: {
        notification: {
          id: notification.id,
          is_read: notification.is_read,
          read_at: notification.read_at
        }
      }
    }
  end

  # PUT /api/v1/mobile/sub_agent/notifications/mark_all_read
  # Mark all notifications as read for the current sub_agent
  def mark_all_notifications_read
    notifications = Notification.for_sub_agent(current_sub_agent.id).unread

    notifications.update_all(
      is_read: true,
      read_at: Time.current,
      updated_at: Time.current
    )

    render json: {
      success: true,
      message: "#{notifications.count} notifications marked as read"
    }
  end

  # GET /api/v1/mobile/sub_agent/notifications/unread_count
  # Get unread notification count for the current sub_agent
  def unread_notifications_count
    count = Notification.for_sub_agent(current_sub_agent.id).unread.count

    render json: {
      success: true,
      data: {
        unread_count: count
      }
    }
  end

  private

  def validate_sub_agent_access
    unless current_user.is_a?(SubAgent)
      render json: {
        success: false,
        message: 'Access denied. Sub-agent account required.'
      }, status: :forbidden
    end
  end

  def current_sub_agent
    current_user # current_user is already a SubAgent object from authenticate_customer!
  end

  def notification_reference_details(reference)
    case reference
    when ClientRequest
      {
        ticket_number: reference.ticket_number,
        subject: reference.subject,
        status: reference.status
      }
    else
      {
        class: reference.class.name,
        id: reference.id
      }
    end
  end
end