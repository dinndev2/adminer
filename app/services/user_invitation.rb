class UserInvitation
  Result = Struct.new(:record, :success?, :errors)
  def initialize(new_user, admin)
    @user = new_user
    @admin = admin
  end

 
  def prepare
    temp_password = SecureRandom.hex(10)
    @user.password = temp_password
    @user.password_confirmation = temp_password
    @user.role = 'member'
    if @user.save
      Result.new(@user, true, nil)
    else
      Result.new(@user, false, @user.errors)
    end
  end
 
  def invite
    result = self.prepare    
    if result.success?
      User.invite!(email: @user.email, name: @user.name)
      @admin.owned_managements.create(member: @user, admin: @admin)
    end
    result
  end
end