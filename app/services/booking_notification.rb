class BookingNotification
  def initialize(booking)
    @booking = booking
  end

  def booked!
    BookingMailer.with(booking_id: @booking.id).customer_confirmation.deliver_now
    if self.more_than_five_days_away?
      BookingReminderJob.set(wait_until: @booking.to.in_time_zone - 3.days).perform_later(@booking.id)
    end
    if @booking.assigned_to
      BookingMailer.with(booking_id: @booking.id).booking_assigned_reminder.deliver_now
    end
  end

  def more_than_five_days_away?
    @booking.to > 5.days.from_now
  end
end