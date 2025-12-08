class Admin::CustomersController < Admin::ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /admin/customers
  def index
    @customers = Customer.includes(:policies)

    # Search functionality
    if params[:search].present?
      @customers = @customers.search_customers(params[:search])
    end

    # Filter by customer type
    if params[:customer_type].present?
      @customers = @customers.where(customer_type: params[:customer_type])
    end

    # Filter by status
    case params[:status]
    when 'active'
      @customers = @customers.active
    when 'inactive'
      @customers = @customers.inactive
    end

    @customers = @customers.order(created_at: :desc).page(params[:page])

    # Statistics
    @total_customers = Customer.count
    @active_customers = Customer.active.count
    @individual_customers = Customer.individuals.count
    @corporate_customers = Customer.corporates.count
  end

  # GET /admin/customers/1
  def show
    @family_members = @customer.family_members.order(:created_at)
    @policies = @customer.policies.includes(:insurance_company).order(created_at: :desc)
  end

  # GET /admin/customers/new
  def new
    @customer = Customer.new
    @customer.status = true
    @customer.sub_agent = "Self"
  end

  # GET /admin/customers/1/edit
  def edit
  end

  # POST /admin/customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to admin_customer_path(@customer), notice: 'Customer was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/customers/1
  def update
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: 'Customer was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/customers/1
  def destroy
    if @customer.policies.exists?
      redirect_to admin_customers_path, alert: 'Cannot delete customer with existing policies.'
    else
      @customer.destroy
      redirect_to admin_customers_path, notice: 'Customer was successfully deleted.'
    end
  end

  # PATCH /admin/customers/1/toggle_status
  def toggle_status
    @customer.update(status: !@customer.status)
    status_text = @customer.status? ? 'activated' : 'deactivated'
    redirect_to admin_customers_path, notice: "Customer was successfully #{status_text}."
  end

  # GET /admin/customers/export
  def export
    @customers = Customer.includes(:policies)

    # Apply same filters as index
    if params[:search].present?
      @customers = @customers.search_customers(params[:search])
    end

    if params[:customer_type].present?
      @customers = @customers.where(customer_type: params[:customer_type])
    end

    case params[:status]
    when 'active'
      @customers = @customers.active
    when 'inactive'
      @customers = @customers.inactive
    end

    @customers = @customers.order(:created_at)

    respond_to do |format|
      format.csv do
        send_data generate_customers_csv(@customers), filename: "customers_#{Date.current}.csv"
      end
      # format.xlsx do
      #   send_data generate_customers_xlsx(@customers), filename: "customers_#{Date.current}.xlsx"
      # end
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :customer_type, :first_name, :middle_name, :last_name, :company_name, :email, :mobile,
      :address, :state, :city, :pincode, :pan_no, :gst_no, :birth_date,
      :gender, :occupation, :annual_income, :nominee_name, :nominee_relation,
      :nominee_date_of_birth, :status, :birth_place, :height_feet, :weight_kg, :education,
      :marital_status, :business_job, :business_name, :type_of_duty, :additional_information,
      :added_by, :sub_agent, :age,
      profile_image: [],
      documents_attributes: [:id, :document_type, :file, :_destroy],
      family_members_attributes: [
        :id, :first_name, :middle_name, :last_name, :birth_date, :age, :height_feet, :weight_kg,
        :gender, :relationship, :pan_no, :mobile, :additional_information, :_destroy,
        documents_attributes: [:id, :document_type, :file, :_destroy]
      ],
      corporate_members_attributes: [
        :id, :company_name, :mobile, :email, :state, :city, :address, :annual_income,
        :pan_no, :gst_no, :additional_information, :_destroy,
        documents_attributes: [:id, :document_type, :file, :_destroy]
      ]
    )
  end

  def generate_customers_csv(customers)
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << %w[
        ID CustomerType FirstName LastName CompanyName Email Mobile
        Address State City Pincode BirthDate Gender Height Weight
        Education MaritalStatus Occupation JobName TypeOfDuty AnnualIncome
        PANNumber GSTNumber BirthPlace NomineeName NomineeRelation
        NomineeDOB Status AddedBy CreatedAt
      ]

      customers.find_each do |customer|
        csv << [
          customer.id,
          customer.customer_type&.humanize,
          customer.first_name,
          customer.last_name,
          customer.company_name,
          customer.email,
          customer.mobile,
          customer.address,
          customer.state,
          customer.city,
          customer.pincode,
          customer.birth_date,
          customer.gender&.humanize,
          customer.height,
          customer.weight,
          customer.education,
          customer.marital_status&.humanize,
          customer.occupation,
          customer.job_name,
          customer.type_of_duty,
          customer.annual_income,
          customer.pan_number,
          customer.gst_number,
          customer.birth_place,
          customer.nominee_name,
          customer.nominee_relation,
          customer.nominee_date_of_birth,
          customer.status? ? 'Active' : 'Inactive',
          customer.added_by&.humanize,
          customer.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end
  end

  def generate_customers_xlsx(customers)
    require 'rubyXL'

    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Customers'

    # Headers
    headers = %w[
      ID CustomerType FirstName LastName CompanyName Email Mobile
      Address State City Pincode BirthDate Gender Height Weight
      Education MaritalStatus Occupation JobName TypeOfDuty AnnualIncome
      PANNumber GSTNumber BirthPlace NomineeName NomineeRelation
      NomineeDOB Status AddedBy CreatedAt
    ]

    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
      worksheet.sheet_data[0][index].change_font_bold(true)
    end

    # Data rows
    customers.each_with_index do |customer, row_index|
      row = row_index + 1
      data = [
        customer.id,
        customer.customer_type&.humanize,
        customer.first_name,
        customer.last_name,
        customer.company_name,
        customer.email,
        customer.mobile,
        customer.address,
        customer.state,
        customer.city,
        customer.pincode,
        customer.birth_date,
        customer.gender&.humanize,
        customer.height,
        customer.weight,
        customer.education,
        customer.marital_status&.humanize,
        customer.occupation,
        customer.job_name,
        customer.type_of_duty,
        customer.annual_income,
        customer.pan_number,
        customer.gst_number,
        customer.birth_place,
        customer.nominee_name,
        customer.nominee_relation,
        customer.nominee_date_of_birth,
        customer.status? ? 'Active' : 'Inactive',
        customer.added_by&.humanize,
        customer.created_at.strftime('%Y-%m-%d %H:%M:%S')
      ]

      data.each_with_index do |value, col_index|
        worksheet.add_cell(row, col_index, value)
      end
    end

    workbook.stream.string
  end
end