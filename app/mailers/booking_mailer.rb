class BookingMailer < ApplicationMailer
  before_action :prepare_booking, except: :book

  def customer_confirmation
    mail(to: @customer.email, subject: "Booking Confirmation")
  end

  def customer_reminder
    mail(to: @customer.email, subject: "Booking Ending")
  end

  def booking_assigned_reminder
    mail(to: @customer.email, subject: "Booking Confirmation for #{@customer.name || "User"}")
  end

  private

  def prepare_booking
    @booking = params.fetch(:booking) { Booking.find(params.fetch(:booking_id)) }
    @customer = @booking.customer
  end
end
