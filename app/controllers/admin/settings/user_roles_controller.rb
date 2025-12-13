class Admin::Settings::UserRolesController < Admin::Settings::BaseController
  before_action :set_user_role, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @user_roles = UserRole.includes(:users).ordered
    @user_roles = @user_roles.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?

    respond_to do |format|
      format.html
      format.json { render json: @user_roles }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user_role }
    end
  end

  def new
    @user_role = UserRole.new
    @user_role.display_order = UserRole.maximum(:display_order).to_i + 1
  end

  def edit
  end

  def create
    @user_role = UserRole.new(user_role_params)

    respond_to do |format|
      if @user_role.save
        format.html { redirect_to admin_settings_user_role_path(@user_role), notice: 'User role was successfully created.' }
        format.json { render json: @user_role, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_role.update(user_role_params)
        format.html { redirect_to admin_settings_user_role_path(@user_role), notice: 'User role was successfully updated.' }
        format.json { render json: @user_role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @user_role.destroy
      respond_to do |format|
        format.html { redirect_to admin_settings_user_roles_path, notice: 'User role was successfully deleted.' }
        format.json { render json: { status: 'success', message: 'User role deleted successfully' } }
      end
    rescue ActiveRecord::InvalidForeignKey
      respond_to do |format|
        format.html { redirect_to admin_settings_user_roles_path, alert: 'Cannot delete role that is assigned to users.' }
        format.json { render json: { status: 'error', message: 'Cannot delete role that is assigned to users' }, status: :unprocessable_entity }
      end
    end
  end

  def toggle_status
    @user_role.update(status: !@user_role.status)

    respond_to do |format|
      format.html { redirect_to admin_settings_user_roles_path, notice: "Role #{@user_role.status? ? 'activated' : 'deactivated'} successfully." }
      format.json { render json: { status: 'success', active: @user_role.status? } }
    end
  end

  private

  def set_user_role
    @user_role = UserRole.find(params[:id])
  end

  def user_role_params
    params.require(:user_role).permit(:name, :description, :status, :display_order)
  end
end