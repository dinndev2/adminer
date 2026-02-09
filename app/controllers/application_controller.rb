class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_businesses, if: :user_signed_in?


  private

  def set_businesses
    @tenant = current_user.admin? ? current_user.tenant : current_user.invited_by_tenant
    @businesses = @tenant.businesses
  end

  def check_if_supercharged
    return if @tenant.supercharged?
    redirect_to root_path
  end

  def admin_accessible
    return if current_user.nil?
    redirect_to root_path if current_user.member?
  end
end
