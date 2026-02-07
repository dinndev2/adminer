module BookingsHelper
  def booking_date(booking)
    "#{booking.from.strftime("%b %d, %Y")} - #{booking.to.strftime("%b %d, %Y") }"
  end
end
