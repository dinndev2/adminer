class Users::OnboardingController < ApplicationController
  include Wicked::Wizard
  layout 'onboarding'
  helper_method :previous_step

  before_action :authenticate_user!
  before_action :set_user
  before_action :onboard_same_user

  steps :general, :company_setup, :confirmation

  def show
    render_wizard
  end

  def update  
    case step
    when :general
      @user.assign_attributes(user_params)      
      if @user.save  
        redirect_to wizard_path(:company_setup)
      else
        render :general, status: :unprocessable_entity
      end
    when :company_setup
      @tenant = Tenant.new(tenant_params)
      if @tenant.save
        redirect_to wizard_path(:confirmation)
      else
        render :company_setup, status: :unprocessable_entity
      end
    when :confirmation
      redirect_to finish_wizard_path
    end
  end

  private

  def finish_wizard_path
    root_path(current_user)
  end

  def user_params
    params.expect(user: [:name, :avatar])
  end

  def tenant_params
    params.expect(tenant: [:name, :description, :color])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def onboard_same_user
    return if @user == current_user 
    redirect_to root_path
  end
end