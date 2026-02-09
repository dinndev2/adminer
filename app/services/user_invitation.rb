class UserInvitation
  Result = Struct.new(:record, :success?, :errors)

  def initialize(new_user, admin)
    @user = new_user
    @admin = admin
  end

 
  def prepare
    # generate temp password 
    temp_password = SecureRandom.hex(10)
    @user.password = temp_password
    @user.password_confirmation = temp_password
    if @user.save
      Result.new(@user, true, nil)
    else
      Result.new(@user, false, @user.errors)
    end
  end
 
  def invite
    result = self.prepare    
    if result.success?
      @user.invite!(@admin)
      User.transaction do
        Management.find_or_create_by(member: @user, admin: @admin)
        @user.update!(tenant: @admin.tenant)
      end
    end
    result
  end
end