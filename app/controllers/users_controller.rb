class UsersController < ApplicationController
  before_action :admin_accessible, only: [:create, :new]
  
  def create
    @user = User.find_or_initialize_by(user_params)
    result = UserInvitation.new(@user, current_user).invite
    if result.success?
      respond_to do |format|
        format.html { redirect_to settings_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def index
    @users = User.all
  end 

  def new
    @user = User.new
  end

  private

  def user_params
    params.expect(user: [:name, :email, :role])
  end
end