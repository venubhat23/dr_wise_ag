class Admin::HelpdeskController < Admin::ApplicationController
  before_action :authenticate_user!

  def index
    # Get real statistics from ClientRequest model
    @total_tickets = ClientRequest.count
    @open_tickets = ClientRequest.where(status: ['pending', 'in_progress']).count
    @resolved_today = ClientRequest.where(status: ['resolved', 'closed'], resolved_at: Date.current.beginning_of_day..Date.current.end_of_day).count
    @avg_response_time = calculate_avg_response_time

    # Apply filters
    @tickets = ClientRequest.includes(:resolved_by, :submitter).recent
    @tickets = @tickets.where(status: params[:status]) if params[:status].present?
    @tickets = @tickets.where(priority: params[:priority]) if params[:priority].present?
    @tickets = @tickets.where(category: params[:category]) if params[:category].present?

    # Filter by customer tickets only
    if params[:customer_only] == 'true'
      @tickets = @tickets.where(submitter_type: 'Customer')
    end

    # Apply search
    if params[:search].present?
      @tickets = @tickets.search_requests(params[:search])
    end

    # Pagination
    @tickets = @tickets.page(params[:page]).per(20)

    # Get recent tickets for dashboard (limit to 10 most recent)
    @recent_tickets = ClientRequest.includes(:resolved_by, :submitter)
                                  .recent
                                  .limit(10)
                                  .map do |ticket|
      {
        id: ticket.ticket_number,
        customer: ticket.submitter&.display_name || ticket.name,
        subject: ticket.subject,
        status: ticket.status.humanize,
        priority: ticket.priority.humanize,
        created_at: ticket.submitted_at,
        assigned_to: ticket.resolved_by&.name || "Unassigned",
        ticket_obj: ticket
      }
    end

    # Real statistics by status — computed once and reused below instead of
    # being queried again for @stats.
    pending_count     = ClientRequest.pending.count
    in_progress_count = ClientRequest.in_progress.count
    resolved_count    = ClientRequest.resolved.count
    closed_count      = ClientRequest.closed.count

    @ticket_stats_by_status = [
      { status: "Pending", count: pending_count, color: "#ff6b6b" },
      { status: "In Progress", count: in_progress_count, color: "#4ecdc4" },
      { status: "Resolved", count: resolved_count, color: "#45b7d1" },
      { status: "Closed", count: closed_count, color: "#6c757d" }
    ]

    # Monthly trend data (last 12 months) — one grouped query instead of 12.
    monthly_counts = ClientRequest.group_by_month(:submitted_at, last: 12).count
    @monthly_ticket_trend = (11.downto(0)).map do |i|
      month_start = i.months.ago.beginning_of_month
      {
        month: month_start.strftime('%b'),
        tickets: monthly_counts[month_start.to_date] || 0
      }
    end

    # Additional statistics
    @stats = {
      total: @total_tickets,
      pending: pending_count,
      in_progress: in_progress_count,
      resolved: resolved_count,
      closed: closed_count,
      high_priority: ClientRequest.where(priority: 'high').count,
      urgent_priority: ClientRequest.where(priority: 'urgent').count,
      customer_tickets: ClientRequest.where(submitter_type: 'Customer').count,
      agent_tickets: ClientRequest.where(submitter_type: 'SubAgent').count
    }
  end

  def show
    @ticket_id = params[:id]
  end

  def analytics
    # Analytics page
  end

  def tickets
    # Tickets listing page
  end

  def knowledge_base
    # Knowledge base page
  end

  def update_status
    # Update ticket status
    redirect_to admin_helpdesk_index_path, notice: "Ticket status updated successfully"
  end

  def assign_to
    # Assign ticket to agent
    redirect_to admin_helpdesk_index_path, notice: "Ticket assigned successfully"
  end

  def add_response
    # Add response to ticket
    redirect_to admin_helpdesk_index_path, notice: "Response added successfully"
  end

  # Add new method to show customer tickets specifically
  def customer_tickets
    @tickets = ClientRequest.includes(:resolved_by, :submitter)
                           .where(submitter_type: 'Customer')
                           .recent

    # Apply filters
    @tickets = @tickets.where(status: params[:status]) if params[:status].present?
    @tickets = @tickets.where(priority: params[:priority]) if params[:priority].present?
    @tickets = @tickets.where(category: params[:category]) if params[:category].present?

    # Apply search
    if params[:search].present?
      @tickets = @tickets.search_requests(params[:search])
    end

    # Pagination
    @tickets = @tickets.page(params[:page]).per(20)

    # Statistics specific to customer tickets
    @customer_stats = {
      total: ClientRequest.where(submitter_type: 'Customer').count,
      pending: ClientRequest.where(submitter_type: 'Customer', status: 'pending').count,
      in_progress: ClientRequest.where(submitter_type: 'Customer', status: 'in_progress').count,
      resolved: ClientRequest.where(submitter_type: 'Customer', status: 'resolved').count,
      closed: ClientRequest.where(submitter_type: 'Customer', status: 'closed').count
    }

    render :customer_tickets
  end

  private

  def calculate_avg_response_time
    avg_seconds = ClientRequest.where.not(resolved_at: nil)
                                .average(Arel.sql('EXTRACT(EPOCH FROM (resolved_at - submitted_at))'))
    return "N/A" if avg_seconds.nil?

    avg_hours = avg_seconds.to_f / 3600.0

    if avg_hours < 1
      "#{(avg_hours * 60).round}m"
    elsif avg_hours < 24
      "#{avg_hours.round(1)}h"
    else
      "#{(avg_hours / 24).round(1)}d"
    end
  end

  def helpdesk_params
    params.require(:helpdesk).permit(:subject, :description, :priority, :status, :assigned_to)
  end
end