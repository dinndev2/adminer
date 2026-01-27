class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern


  private

  def admin_accessible?
    return if current_user.nil?
    redirect_to root_path if current_user.member?
  end
end
