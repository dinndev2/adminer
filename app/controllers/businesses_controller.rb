class BusinessesController < ApplicationController
  before_action :check_if_supercharged, only: :create
  before_action :admin_accessible

  def create 
    @business = Business.new(business_params)
    if @business.save 
      redirect_to business_bookings_path(@business)
    else
      respond_to do |f|
        f.turbo_stream { render turbo_stream: turbo_stream.update("business-form", partial: "businesses/form", locals: {business: @business}), status: :unprocessable_entity }
      end
    end
  end

  private
  def business_params
    params.expect(business: [:name, :tenant_id])
  end
end
