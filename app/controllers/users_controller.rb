class UsersController < ApplicationController
  
  def update
    
  end

  private

  def user_params
    params.expect(user: [:name])
  end
end