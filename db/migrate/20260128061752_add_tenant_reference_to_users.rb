class AddTenantReferenceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :tenant, foreign_key: true
  end
end
