class Admin::MotorInsurancesController < Admin::ApplicationController
  before_action :set_motor_insurance, only: [:show, :edit, :update, :destroy]

  def index
    @motor_insurances = Policy.where(insurance_type: 'motor').includes(:customer, :insurance_company)
    @motor_insurances = @motor_insurances.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @motor_insurance = Policy.new(insurance_type: 'motor')
    @customers = Customer.active.order(:first_name)
  end

  def edit
    @customers = Customer.active.order(:first_name)
  end

  def create
    @motor_insurance = Policy.new(motor_insurance_params)
    @motor_insurance.insurance_type = 'motor'
    @motor_insurance.user = current_user

    if @motor_insurance.save
      redirect_to admin_motor_insurance_path(@motor_insurance), notice: 'Motor insurance policy was successfully created.'
    else
      @customers = Customer.active.order(:first_name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @motor_insurance.update(motor_insurance_params)
      redirect_to admin_motor_insurance_path(@motor_insurance), notice: 'Motor insurance policy was successfully updated.'
    else
      @customers = Customer.active.order(:first_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @motor_insurance.destroy
    redirect_to admin_motor_insurances_path, notice: 'Motor insurance policy was successfully deleted.'
  end

  private

  def set_motor_insurance
    @motor_insurance = Policy.where(insurance_type: 'motor').find(params[:id])
  end

  def motor_insurance_params
    params.require(:policy).permit(
      :customer_id, :insurance_company_id, :policy_number, :policy_type,
      :sum_insured, :premium_amount, :total_premium, :premium_frequency,
      :start_date, :end_date, :nominee_name, :nominee_relation, :status,
      :additional_details
    )
  end
end