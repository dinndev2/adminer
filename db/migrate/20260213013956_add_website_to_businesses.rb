class AddWebsiteToBusinesses < ActiveRecord::Migration[8.0]
  def change
    add_column :businesses, :website, :string
  end
end
