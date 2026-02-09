# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def home
    @bookings = current_user.admin? ? @tenant.bookings : current_user.bookings

    @in_progress_bookings = @bookings.not_finish
    @finished_bookings    = @bookings.finished
    @new_bookings         = @bookings.created

    @todays_bookings      = @bookings.today
    @this_week_bookings   = @bookings.this_week
    @ending_this_week     = @bookings.ending_this_week
        
  end
end
