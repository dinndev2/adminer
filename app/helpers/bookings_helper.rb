module BookingsHelper
  def booking_date(booking)
    "#{booking.from.strftime("%b %d, %Y")} - #{booking.to.strftime("%b %d, %Y")}"
  end

  STATUS_STYLES = {
    "created" => {
      dot:  "bg-sky-500",
      head: "border-sky-200 bg-sky-50",
      pill: "bg-sky-100 text-sky-800 ring-sky-200",
      card: "border-sky-200",
      bar:  "bg-sky-500"
    },
    "not_finish" => {
      dot:  "bg-amber-500",
      head: "border-amber-200 bg-amber-50",
      pill: "bg-amber-100 text-amber-800 ring-amber-200",
      card: "border-amber-200",
      bar:  "bg-amber-500"
    },
    "finished" => {
      dot:  "bg-emerald-500",
      head: "border-emerald-200 bg-emerald-50",
      pill: "bg-emerald-100 text-emerald-800 ring-emerald-200",
      card: "border-emerald-200",
      bar:  "bg-emerald-500"
    }
  }.freeze

  def status_style(key)
    STATUS_STYLES.fetch(key.to_s) do
      {
        dot: "bg-gray-400",
        head: "border-gray-200 bg-gray-50",
        pill: "bg-gray-100 text-gray-800 ring-gray-200",
        card: "border-gray-200",
        bar: "bg-gray-400"
      }
    end
  end
end
