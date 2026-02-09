class UsersController < ApplicationController
  before_action :admin_accessible, only: [:create, :new]
  before_action :set_user, only: [:update]
  
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

  def update
    return redirect_to root_path unless @user == current_user || current_user.admin?
    if @user.update(user_update_params)
      respond_to do |f|
        f.turbo_stream do
          flash.now[:profile_saved] = "Profile updated."
          render turbo_stream: turbo_stream.replace("user-settings", partial: "users/user_settings", locals: { user: @user })
        end
        f.html do
          flash[:profile_saved] = "Profile updated."
          redirect_to user_settings_path
        end
      end
    else
      @users = User.all
      render :index, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:name, :email, :role])
  end

  def user_update_params
    return params.expect(user: [:name, :email, :role, :avatar]) if current_user.admin? && @user != current_user
    params.expect(user: [:name, :email, :avatar])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
