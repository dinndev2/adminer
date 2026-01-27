class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create

  end
   
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

  def booking_params
    params.expect(booking: [:name, :description, :from, :to, :duration, customer_attributes: [:name, :phone, :address, :id, :_destroy]])
  end 
end
