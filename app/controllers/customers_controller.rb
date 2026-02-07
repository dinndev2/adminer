class CustomersController < ApplicationController
  before_action :authenticate_user!

  def search
    q = params[:q].to_s.strip # convert the user query to string and strip to remove white space :)
    @customers = if q.length >= 1
      Customer.where("name ILIKE ? or phone ILIKE ?", "%#{q}%", "%#{q}%")
      else
        Customer.all.limit(20)
      end
    # return json for for obj response
    
    
    render json: @customers.map do |user| 
      {
        id: user.id,
        name: user.name,
        phone: user.phone,
        address: user.address
      }
    end 
  end
end
