class AddPositionToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :position, :integer
  end
end
