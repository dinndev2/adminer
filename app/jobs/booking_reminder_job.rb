class BookingReminderJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    return unless booking
    return unless booking.in_progress?

    BookingMailer.with(booking_id: booking.id).customer_reminder
  end
end
