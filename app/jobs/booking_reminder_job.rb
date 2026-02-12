class BookingReminderJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking
    return unless booking.not_finish?  
    BookingMailer.with(booking_id: booking.id).customer_reminder.deliver_later
  end
end
