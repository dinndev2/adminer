class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assignee_selection
  before_action :set_business
  before_action :set_booking_data, only: :index
  
   
  def new
    @booking = Booking.new
  end

  def show
     @booking = Booking.find(params[:id])
  end

  def create
    @booking = Booking.new(booking_params)
    result = BookingCreation.new(@booking).set
    if result.success?
      respond_to do |format|
        format.html { redirect_to bookings_path, status: :ok }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def move
    booking = Booking.find(params[:id])
    @column  = params[:column]
    @prev_column = params[:prev_column]
    index   = params[:position].to_i
    
    @updated_new_count = 2
    @updated_prev_count = 4

    Booking.transaction do
      booking.update!(status: @column)

      # reindex that column based on current order excluding this booking
      ids = Booking.where(status: @column).where.not(id: booking.id).order(:position).pluck(:id)

      # insert at new index
      ids.insert(index, booking.id)

      # write positions 0..n
      ids.each_with_index do |id, i|
        Booking.where(id: id).update_all(position: i)
      end
    end
    respond_to do |f|
      f.turbo_stream
    end
  end


  def index
    @booking = Booking.new
  end

  private

  def set_assignee_selection
    @members = current_user.members 
  end

  def set_booking_data
    @bookings = current_user.personalized_bookings(@business)

    @booking_columns = { 
      "created" => {title: "Created", bookings: @bookings.created},
      "not_finish" => {title: "Not Finish", bookings: @bookings.not_finish},
      "finished" => {title: "Finished", bookings: @bookings.finished}
    }
  end

  def set_business
    @business = Business.find(params[:business_id])
  end

  def booking_params
    params.expect(booking: [:name, :description, :from, :to, :duration, :user_id, :customer_id, :service_id, :business_id])
  end  
end
