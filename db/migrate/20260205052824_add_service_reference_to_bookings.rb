class AddServiceReferenceToBookings < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :service, foreign_key: true
  end
end
