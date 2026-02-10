class AddCreatorIdToBookings < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :creator, foreign_key: { to_table: :users }, index: true
  end
end
