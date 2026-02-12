class AddDateTypeAndRecurringToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :recurring, :boolean, default: false
    add_column :bookings, :recurring_type, :integer, default: 0
  end
end
