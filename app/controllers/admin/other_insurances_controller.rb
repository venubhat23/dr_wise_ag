class Admin::OtherInsurancesController < Admin::ApplicationController
  before_action :set_other_insurance, only: [:show, :edit, :update, :destroy]

  def index
    @other_insurances = Policy.where(insurance_type: 'other').includes(:customer, :insurance_company)
    @other_insurances = @other_insurances.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @other_insurance = Policy.new(insurance_type: 'other')
    @customers = Customer.active.order(:first_name)
  end

  def edit
    @customers = Customer.active.order(:first_name)
  end

  def create
    @other_insurance = Policy.new(other_insurance_params)
    @other_insurance.insurance_type = 'other'
    @other_insurance.user = current_user

    if @other_insurance.save
      redirect_to admin_other_insurance_path(@other_insurance), notice: 'Other insurance policy was successfully created.'
    else
      @customers = Customer.active.order(:first_name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @other_insurance.update(other_insurance_params)
      redirect_to admin_other_insurance_path(@other_insurance), notice: 'Other insurance policy was successfully updated.'
    else
      @customers = Customer.active.order(:first_name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @other_insurance.destroy
    redirect_to admin_other_insurances_path, notice: 'Other insurance policy was successfully deleted.'
  end

  private

  def set_other_insurance
    @other_insurance = Policy.where(insurance_type: 'other').find(params[:id])
  end

  def other_insurance_params
    params.require(:policy).permit(
      :customer_id, :insurance_company_id, :policy_number, :policy_type,
      :sum_insured, :premium_amount, :total_premium, :premium_frequency,
      :start_date, :end_date, :nominee_name, :nominee_relation, :status,
      :additional_details
    )
  end
end