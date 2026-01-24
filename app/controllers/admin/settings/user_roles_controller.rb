class Admin::Settings::UserRolesController < Admin::Settings::BaseController
  include ConfigurablePagination
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @users = User.where(user_type: ['admin', 'agent']).order(:created_at)
    @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    @users = paginate_records(@users)
  end

  def show
  end

  def new
    @user = User.new
    @sidebar_options = get_sidebar_options
  end

  def edit
    @sidebar_options = get_sidebar_options
  end

  def create
    @user = User.new(user_params)
    @user.user_type = 'admin'
    @user.status = true

    # Store the plain password temporarily for display (before it gets encrypted)
    plain_password = @user.password

    if @user.save
      # Store the original password for showing on the user management page
      @user.update_column(:original_password, plain_password) if plain_password.present?

      # Set special flash to indicate user was just created
      flash[:user_created] = true
      redirect_to admin_settings_user_role_path(@user), notice: 'User was successfully created.'
    else
      @sidebar_options = get_sidebar_options
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_settings_user_role_path(@user), notice: 'User was successfully updated.'
    else
      @sidebar_options = get_sidebar_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_settings_user_roles_path, notice: 'User was successfully deleted.'
  end

  def toggle_status
    @user.update(status: !@user.status)
    redirect_to admin_settings_user_roles_path, notice: "User #{@user.status? ? 'activated' : 'deactivated'} successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :mobile, :password, :password_confirmation, :role_name, :original_password, sidebar_permissions: [], crud_permissions: {})

    # Handle CRUD permissions - store as JSON in sidebar_permissions field
    if params[:user][:crud_permissions].present?
      # Process CRUD permissions into a structured format
      crud_data = {}
      params[:user][:crud_permissions].each do |module_key, permissions|
        if permissions['all_access'] == '1'
          # For modules with "All Access" checked, grant all permissions
          crud_data[module_key] = {
            'view' => true,
            'create' => true,
            'edit' => true,
            'delete' => true
          }
        else
          # For modules with individual CRUD permissions
          crud_data[module_key] = {
            'view' => permissions['view'] == '1',
            'create' => permissions['create'] == '1',
            'edit' => permissions['edit'] == '1',
            'delete' => permissions['delete'] == '1'
          }
        end
      end

      # Store CRUD permissions as JSON in sidebar_permissions field
      permitted_params[:sidebar_permissions] = crud_data.to_json
    elsif permitted_params[:sidebar_permissions].present?
      # Legacy format - convert array to JSON string for storage
      permitted_params[:sidebar_permissions] = permitted_params[:sidebar_permissions].compact_blank.to_json
    end

    permitted_params
  end

  def get_sidebar_options
    {
      'Main Menu' => [
        { key: 'dashboard', name: 'Dashboard' },
        { key: 'analytics', name: 'Analytics' },
        { key: 'leads', name: 'Leads' },
        { key: 'customers', name: 'Clients' },
        { key: 'sub_agents', name: 'Affiliates' },
        { key: 'distributors', name: 'Ambassadors' }
      ],
      'Services' => [
        { key: 'life_insurance', name: 'Life Insurance' },
        { key: 'health_insurance', name: 'Health Insurance' },
        { key: 'motor_insurance', name: 'Motor Insurance' },
        { key: 'other_insurance', name: 'General Insurance' }
      ],
      'Vendor' => [
        { key: 'brokers', name: 'Broker' },
        { key: 'agency_codes', name: 'Agency Code' }
      ],
      'Payouts' => [
        { key: 'payouts', name: 'Commissions' },
        { key: 'affiliate_payouts', name: 'Affiliate Payout' },
        { key: 'distributor_payouts', name: 'Ambassador Payout' }
      ],
      'Transactions' => [
        { key: 'invoices', name: 'Invoices' }
      ],
      'Reports & Analytics' => [
        { key: 'reports', name: 'Commission Report' },
        { key: 'all_policy_reports', name: 'All Policy Reports' },
        { key: 'expired_insurance_reports', name: 'Expired Insurance' },
        { key: 'upcoming_renewal_reports', name: 'Upcoming Renewal' },
        { key: 'lead_reports', name: 'Lead Reports' }
      ],
      'Management' => [
        { key: 'investors', name: 'Investors' },
        { key: 'client_requests', name: 'Client Request' },
        { key: 'banners', name: 'Banner Management' },
        { key: 'insurance_companies', name: 'Companies' },
        { key: 'management', name: 'Import Data' }
      ],
      'Settings' => [
        { key: 'settings', name: 'System Settings' }
      ]
    }
  end
end