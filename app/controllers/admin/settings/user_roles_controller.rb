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
      # Store the original password for showing on the user details page
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
    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :mobile, :password, :password_confirmation, :role_name, sidebar_permissions: [])

    # Convert sidebar_permissions array to JSON string for storage
    if permitted_params[:sidebar_permissions].present?
      permitted_params[:sidebar_permissions] = permitted_params[:sidebar_permissions].compact_blank.to_json
    end

    permitted_params
  end

  def get_sidebar_options
    {
      'Dashboard' => [
        { key: 'dashboard', name: 'Dashboard' },
        { key: 'analytics', name: 'Analytics' }
      ],
      'Customer Management' => [
        { key: 'customers', name: 'Customers' },
        { key: 'customer_documents', name: 'Customer Documents' },
        { key: 'customer_family', name: 'Family Members' },
        { key: 'customer_communication', name: 'Customer Communication' }
      ],
      'Lead Management' => [
        { key: 'leads', name: 'Leads' },
        { key: 'lead_sources', name: 'Lead Sources' },
        { key: 'lead_tracking', name: 'Lead Tracking' },
        { key: 'lead_conversion', name: 'Lead Conversion' },
        { key: 'follow_ups', name: 'Follow-ups' }
      ],
      'Insurance Products' => [
        { key: 'health_insurance', name: 'Health Insurance' },
        { key: 'motor_insurance', name: 'Motor Insurance' },
        { key: 'life_insurance', name: 'Life Insurance' },
        { key: 'other_insurance', name: 'Other Insurance' },
        { key: 'insurance_comparison', name: 'Insurance Comparison' },
        { key: 'policy_renewals', name: 'Policy Renewals' }
      ],
      'Business Partners' => [
        { key: 'sub_agents', name: 'Affiliates' },
        { key: 'distributors', name: 'Ambassadors' },
        { key: 'investors', name: 'Investors' },
        { key: 'brokers', name: 'Brokers' },
        { key: 'agency_codes', name: 'Agency Codes' },
        { key: 'insurance_companies', name: 'Insurance Companies' }
      ],
      'Commission & Payouts' => [
        { key: 'commission_structure', name: 'Commission Structure' },
        { key: 'affiliate_payouts', name: 'Affiliate Payouts' },
        { key: 'distributor_payouts', name: 'Ambassador Payouts' },
        { key: 'investor_payouts', name: 'Investor Payouts' },
        { key: 'commission_calculations', name: 'Commission Calculations' },
        { key: 'payout_reports', name: 'Payout Reports' },
        { key: 'tds_management', name: 'TDS Management' }
      ],
      'Financial Management' => [
        { key: 'invoices', name: 'Invoices' },
        { key: 'payments', name: 'Payments' },
        { key: 'payment_tracking', name: 'Payment Tracking' },
        { key: 'outstanding_payments', name: 'Outstanding Payments' },
        { key: 'financial_reports', name: 'Financial Reports' },
        { key: 'expense_management', name: 'Expense Management' }
      ],
      'Reports & Analytics' => [
        { key: 'sales_reports', name: 'Sales Reports' },
        { key: 'commission_reports', name: 'Commission Reports' },
        { key: 'performance_analytics', name: 'Performance Analytics' },
        { key: 'customer_analytics', name: 'Customer Analytics' },
        { key: 'business_insights', name: 'Business Insights' },
        { key: 'expired_policies', name: 'Expired Policies' },
        { key: 'upcoming_renewals', name: 'Upcoming Renewals' },
        { key: 'payment_due_reports', name: 'Payment Due Reports' },
        { key: 'leads_reports', name: 'Leads Reports' },
        { key: 'conversion_analytics', name: 'Conversion Analytics' }
      ],
      'Communication' => [
        { key: 'notifications', name: 'Notifications' },
        { key: 'sms_management', name: 'SMS Management' },
        { key: 'email_campaigns', name: 'Email Campaigns' },
        { key: 'whatsapp_integration', name: 'WhatsApp Integration' },
        { key: 'communication_logs', name: 'Communication Logs' }
      ],
      'Document Management' => [
        { key: 'document_templates', name: 'Document Templates' },
        { key: 'policy_documents', name: 'Policy Documents' },
        { key: 'customer_documents', name: 'Customer Documents' },
        { key: 'compliance_documents', name: 'Compliance Documents' },
        { key: 'document_verification', name: 'Document Verification' }
      ],
      'Administration' => [
        { key: 'user_management', name: 'User Management' },
        { key: 'roles_permissions', name: 'Roles & Permissions' },
        { key: 'system_settings', name: 'System Settings' },
        { key: 'audit_logs', name: 'Audit Logs' },
        { key: 'backup_restore', name: 'Backup & Restore' },
        { key: 'system_maintenance', name: 'System Maintenance' }
      ],
      'Marketing & Sales' => [
        { key: 'campaigns', name: 'Marketing Campaigns' },
        { key: 'promotional_banners', name: 'Promotional Banners' },
        { key: 'referral_program', name: 'Referral Program' },
        { key: 'loyalty_program', name: 'Loyalty Program' },
        { key: 'sales_targets', name: 'Sales Targets' },
        { key: 'incentive_management', name: 'Incentive Management' }
      ],
      'Data Management' => [
        { key: 'data_imports', name: 'Data Imports' },
        { key: 'data_exports', name: 'Data Exports' },
        { key: 'data_validation', name: 'Data Validation' },
        { key: 'data_cleanup', name: 'Data Cleanup' },
        { key: 'bulk_operations', name: 'Bulk Operations' }
      ],
      'Integration & API' => [
        { key: 'api_management', name: 'API Management' },
        { key: 'third_party_integrations', name: 'Third Party Integrations' },
        { key: 'webhook_management', name: 'Webhook Management' },
        { key: 'sync_operations', name: 'Sync Operations' }
      ],
      'Support & Help' => [
        { key: 'help_desk', name: 'Help Desk' },
        { key: 'client_requests', name: 'Client Requests' },
        { key: 'support_tickets', name: 'Support Tickets' },
        { key: 'knowledge_base', name: 'Knowledge Base' },
        { key: 'training_materials', name: 'Training Materials' }
      ]
    }
  end
end