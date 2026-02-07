class AddUniqueIndexToTenantsName < ActiveRecord::Migration[8.0]
  def change
    add_index :tenants, :name, unique: true
  end
end
