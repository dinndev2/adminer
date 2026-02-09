class AddTierInTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :tier, :integer, default: 0
  end
end
