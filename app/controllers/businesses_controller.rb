class BusinessesController < ApplicationController
  before_action :check_if_supercharged, only: :create
  def create 
    @business = Business.new(business_params)
    if @business.save 
      redirect_to business_bookings_path(@business)
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def business_params
    params.expect(business: [:name, :tenant_id])
  end
end
