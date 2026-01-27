module UsersHelper
  def displayable_position(user)
    user&.role&.titleize || "Guest"
  end
end