class CreateBusinesses < ActiveRecord::Migration[8.0]
  def change
    create_table :businesses do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :location
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
