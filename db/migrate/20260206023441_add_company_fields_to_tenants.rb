class AddCompanyFieldsToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :website, :string
    add_column :tenants, :industry, :string
    add_column :tenants, :company_size, :string
  end
end
