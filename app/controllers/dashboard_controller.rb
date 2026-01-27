class DashboardController < ApplicationController
  def home 
    @services = Service.all
    @bookings = Booking.all
  end
end 