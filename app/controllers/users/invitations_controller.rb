class Users::InvitationsController < Devise::InvitationsController

  protected

  def after_accept_path_for(resource)
    if resource.admin?
      onboarding_path(:general)
    else
      super
    end
  end
end