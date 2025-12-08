class Admin::BannersController < Admin::ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = Banner.all.order(created_at: :desc)
    @banners = @banners.page(params[:page])
  rescue NameError
    # Handle case where Banner model doesn't exist yet
    redirect_to admin_customers_path, alert: 'Banners functionality not yet implemented.'
  end

  def show
  end

  def new
    @banner = Banner.new
  rescue NameError
    redirect_to admin_customers_path, alert: 'Banners functionality not yet implemented.'
  end

  def edit
  end

  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      redirect_to admin_banner_path(@banner), notice: 'Banner was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  rescue NameError
    redirect_to admin_customers_path, alert: 'Banners functionality not yet implemented.'
  end

  def update
    if @banner.update(banner_params)
      redirect_to admin_banner_path(@banner), notice: 'Banner was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path, notice: 'Banner was successfully deleted.'
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  rescue NameError
    redirect_to admin_customers_path, alert: 'Banners functionality not yet implemented.'
  end

  def banner_params
    params.require(:banner).permit(:title, :description, :image, :link_url, :active, :start_date, :end_date)
  end
end