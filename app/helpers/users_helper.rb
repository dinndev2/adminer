module UsersHelper
  def displayable_position(user)
    user&.role&.titleize || "Guest"
  end

  def admin?(user)
    return if user.nil?
    user.admin? 
  end
end