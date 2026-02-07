module Calendar
  class MonthGrid
    def self.call(month_date, week_start: :sunday)
      start  = month_date.beginning_of_month.beginning_of_week(week_start)
      finish = month_date.end_of_month.end_of_week(week_start)

      (start..finish).map do |date|
        {
          date: date.to_date.iso8601,     # "2026-02-06"
          day: date.day,
          weekday: date.strftime("%a"),
          in_month: date.month == month_date.month
        }
      end
    end
  end
end