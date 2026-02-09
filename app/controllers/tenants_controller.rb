class TenantsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_accessible

  def update
    @tenant = current_user.tenant
    return redirect_to user_settings_path if @tenant.nil?

    if @tenant.update(tenant_params)
      respond_to do |f|
        f.turbo_stream do
          flash.now[:company_saved] = "Company settings updated."
          render turbo_stream: turbo_stream.replace("tenant_settings", partial: "tenants/tenant_settings", locals: { tenant: @tenant })
        end
        f.html do
          flash[:company_saved] = "Company settings updated."
          redirect_to user_settings_path
        end
      end
    else
      @users = User.all
      render "users/index", status: :unprocessable_entity
    end
  end

  private

  def tenant_params
    params.expect(tenant: [:name, :website, :industry, :company_size, :description, :logo, :color])
  end
end
