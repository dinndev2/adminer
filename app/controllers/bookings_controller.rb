class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assignee_selection

   
  def new
    @booking = Booking.new
    @booking.build_customer
    
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      respond_to do |format|
        format.html { redirect_to bookings_path, status: :ok }
        format.turbo_stream
      end
    else
      @booking.build_customer
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @bookings = Booking.all
    @booking = Booking.new
  end

  private

  def set_assignee_selection
    @members = current_user.members 
  end 

  def booking_params
    params.expect(booking: [:name, :description, :from, :to, :duration, :user_id, customer_attributes: [:name, :phone, :address, :id, :_destroy]])
  end 
end
