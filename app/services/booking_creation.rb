class BookingCreation
   Result = Struct.new(:record, :success?, :errors)

  def initialize(booking) 
    @booking = booking
  end

  
  def prepare
    if @booking.save
      Result.new(@booking, true, nil)
    else
      Result.new(@booking, false, @booking.errors)
    end
  end

  def set
    result = self.prepare
    # send booking confirmations to customer and assignee
    if result.success?
      BookingNotification.new(@booking).booked!
    end
    result
  end
end