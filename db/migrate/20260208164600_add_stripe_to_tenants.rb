class AddStripeToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :stripe_customer_id, :string
    add_column :tenants, :stripe_subscription_id, :string
    add_column :tenants, :stripe_subscription_status, :string
    add_column :tenants, :stripe_current_period_end, :datetime
  end
end
