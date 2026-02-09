class AddBusinessReferenceToServices < ActiveRecord::Migration[8.0]
  def change
    add_reference :services, :business, foreign_key: true
  end 
end
