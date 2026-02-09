class AddBusinessReferenceToBookings < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :business, foreign_key: true
  end
end
