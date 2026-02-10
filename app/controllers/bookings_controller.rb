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
    result = BookingServices.new(@booking).set
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
    @booking = @business.bookings.find(params[:id])
    @column  = params[:column]
    @prev_column = params[:prev_column]
    index   = params[:position].to_i
    columns_to_update = [@column, @prev_column].uniq
    broadcast_move = BookingServices.new(@booking, columns_to_update, @current_user, index, @tenant.admin_ids).broadcast
        
    respond_to do |f|
      f.turbo_stream { render "bookings/move", locals: broadcast_move }
      f.html { head :ok }
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
    @booking_columns = current_user.sorted_booking(@bookings)
  end

  def set_business
    @business = Business.find(params[:business_id])
  end

  def booking_params
    params.expect(booking: [:name, :description, :from, :to, :duration, :creator_id, :user_id, :customer_id, :service_id, :business_id])
  end  

  def move_locals_for(user, columns_to_update)
    scoped_bookings = user.personalized_bookings(@business)
    column_bookings = columns_to_update.index_with do |col|
      scoped_bookings.where(status: col).order(:position)
    end

    {
      columns_to_update: columns_to_update,
      column_bookings: column_bookings,
      column_counts: column_bookings.transform_values(&:size)
    }
  end
end
