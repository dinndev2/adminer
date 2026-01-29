class AddColorToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :color, :string
  end
end
