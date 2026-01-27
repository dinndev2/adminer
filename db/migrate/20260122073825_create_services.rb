class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.bigint :price
      t.references :booking, foreign_key: true

      t.timestamps
    end
  end
end