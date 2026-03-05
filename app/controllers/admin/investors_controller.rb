class Admin::InvestorsController < Admin::ApplicationController
  include LocationData
  before_action :set_investor, only: [:show, :edit, :update, :destroy, :toggle_status]

  # GET /admin/investors
  def index
    # Check if search is active first
    search_active = params[:search].present? && params[:search].strip.length >= 4

    @investors = Investor.all

    # Search functionality - only search if 4+ characters or empty
    if params[:search].present?
      search_term = params[:search].strip
      if search_term.length >= 4
        @investors = @investors.search_by_name_mobile_email(search_term) if @investors.respond_to?(:search_by_name_mobile_email)
      elsif search_term.length > 0
        # Return empty result if search term is too short
        @investors = @investors.none
      end
    end

    # Filter by status
    case params[:status]
    when 'active'
      @investors = @investors.active
    when 'inactive'
      @investors = @investors.inactive
    end

    # Get total count before pagination for display purposes
    @total_filtered_count = @investors.count

    # Order and paginate (10 records per page)
    @investors = @investors.order(created_at: :desc).page(params[:page]).per(10)

    # Calculate statistics using separate scope for stats
    stats_scope = Investor.all

    # Apply filters but handle search differently for stats
    if params[:search].present? && params[:search].strip.length >= 4
      # For statistics, use a simple where clause instead of pg_search to avoid GROUP BY issues
      search_term = params[:search].strip
      stats_scope = stats_scope.where(
        "first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR mobile ILIKE ?",
        "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"
      )
    end

    case params[:status]
    when 'active'
      stats_scope = stats_scope.active
    when 'inactive'
      stats_scope = stats_scope.inactive
    end

    # Statistics
    @total_investors = stats_scope.count
    @active_investors = stats_scope.active.count
    @inactive_investors = stats_scope.inactive.count

    # Calculate total investor commission amounts (for existing functionality)
    @total_investor_amount = CommissionPayout.where(payout_to: 'investor').sum(:payout_amount) || 0
    @paid_investor_amount = CommissionPayout.where(payout_to: 'investor', status: 'paid').sum(:payout_amount) || 0
    @pending_investor_amount = CommissionPayout.where(payout_to: 'investor', status: 'pending').sum(:payout_amount) || 0

    # Calculate total invested amount from investors (for share calculations)
    @total_invested_amount = stats_scope.where.not(invested_amount: nil).sum(:invested_amount) || 0
  end

  # GET /admin/investors/1
  def show
    @documents = @investor.investor_documents.order(:created_at)
  end

  # GET /admin/investors/new
  def new
    @investor = Investor.new
    @investor.role_id = 'investor'
    @investor.investor_documents.build
  end

  # GET /admin/investors/1/edit
  def edit
    # Don't build empty documents in edit - let user add them via JavaScript
  end

  # POST /admin/investors
  def create
    @investor = Investor.new(investor_params)
    @investor.role_id = 'investor'

    if @investor.save
      redirect_to admin_investors_path, notice: 'Investor was successfully created.'
    else
      # Build a new document for the form if none exist
      @investor.investor_documents.build if @investor.investor_documents.empty?
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/investors/1
  def update
    # Handle password reset
    if params[:reset_password] == 'true' || params[:reset_password] == '1'
      if params[:new_password_option] == 'manual' && investor_params[:password].present?
        # Manual password provided
        @investor.password = investor_params[:password]
        @investor.original_password = investor_params[:password]
      else
        # Auto-generate new password
        new_password = "Ganesha@123"
        @investor.password = new_password
        @investor.original_password = new_password
      end
    end

    # Remove password fields from update params if not resetting password
    update_params = investor_params
    unless params[:reset_password] == 'true' || params[:reset_password] == '1'
      update_params = update_params.except(:password, :password_confirmation)
    end

    if @investor.update(update_params)
      if params[:reset_password] == 'true' || params[:reset_password] == '1'
        redirect_to admin_investors_path, notice: 'Investor was successfully updated and password was reset.'
      else
        redirect_to admin_investors_path, notice: 'Investor was successfully updated.'
      end
    else
      # Don't build empty documents on error - just re-render
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/investors/1
  def destroy
    begin
      # Simply delete the investor record only
      investor_name = @investor.display_name
      @investor.destroy!

      redirect_to admin_investors_path, notice: "Investor #{investor_name} was successfully deleted."

    rescue StandardError => e
      Rails.logger.error "Failed to delete investor #{@investor.id}: #{e.message}"
      redirect_to admin_investors_path, alert: "Failed to delete investor: #{e.message}"
    end
  end

  # PATCH /admin/investors/1/toggle_status
  def toggle_status
    new_status = @investor.active? ? :inactive : :active

    if @investor.update(status: new_status)
      redirect_to admin_investors_path, notice: "Investor status updated to #{new_status}."
    else
      redirect_to admin_investors_path, alert: 'Failed to update status.'
    end
  end

  private

  def set_investor
    @investor = Investor.find(params[:id])
  end

  def investor_params
    params.require(:investor).permit(
      :first_name, :middle_name, :last_name, :mobile, :email, :role_id,
      :state_id, :city_id, :birth_date, :gender, :pan_no, :gst_no,
      :company_name, :address, :bank_name, :account_no, :ifsc_code,
      :account_holder_name, :account_type, :upi_id, :status, :upload_main_document,
      :username, :password, :password_confirmation, :original_password,
      :invested_amount, :investment_percentage,
      investor_documents_attributes: [:id, :document_type, :document_file, :_destroy]
    )
  end
end
