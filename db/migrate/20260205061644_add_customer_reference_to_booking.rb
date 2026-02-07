class AddCustomerReferenceToBooking < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :customer, foreign_key: true
  end
end
