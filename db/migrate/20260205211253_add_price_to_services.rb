class AddPriceToServices < ActiveRecord::Migration[8.0]
  def change
    remove_column :services, :price
    add_column :services, :price, :decimal, precision: 10, scale: 2
  end
end
