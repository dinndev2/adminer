class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :name
      t.text :description
      t.date :from
      t.date :to
      t.integer :duration

      t.timestamps
    end
  end
end
