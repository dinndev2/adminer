class CreateManagements < ActiveRecord::Migration[8.0]
  def change
    create_table :managements do |t|
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.references :member, null: false, foreign_key:  { to_table: :users }

      t.timestamps
    end
  end
end
