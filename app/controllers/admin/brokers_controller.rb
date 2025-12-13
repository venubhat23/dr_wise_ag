class Admin::BrokersController < Admin::ApplicationController
  before_action :set_broker, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @brokers = Broker.all
    @brokers = @brokers.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @brokers = @brokers.order(:name)
    @broker = Broker.new

    # Statistics for dashboard cards
    @total_brokers = Broker.count
    @active_brokers = Broker.active.count
    @inactive_brokers = Broker.inactive.count
  end

  def show
  end

  def new
    @broker = Broker.new
  end

  def create
    @broker = Broker.new(broker_params)

    if @broker.save
      redirect_to admin_brokers_path, notice: 'Broker was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @broker.update(broker_params)
      redirect_to admin_brokers_path, notice: 'Broker was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @broker.destroy
    redirect_to admin_brokers_path, notice: 'Broker was successfully deleted.'
  end

  def toggle_status
    @broker.update(status: @broker.active? ? 'inactive' : 'active')
    redirect_to admin_brokers_path, notice: 'Broker status was successfully updated.'
  end

  private

  def set_broker
    @broker = Broker.find(params[:id])
  end

  def broker_params
    params.require(:broker).permit(:name, :status)
  end
end