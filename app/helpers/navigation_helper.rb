module NavigationHelper
  NavItem = Struct.new(:label, :path, :icon, :starts_with, keyword_init: true)

  def nav_items(booking)
    [
      NavItem.new(label: "Bookings",  path: business_bookings_path(booking),     icon: :calendar, starts_with: "/businesses/#{booking.id}/bookings"),
      NavItem.new(label: "Services",  path: business_services_path(booking),     icon: :tag,      starts_with: "/businesses/#{booking.id}/services"),
    ]
  end

  def dashboard_item
    NavItem.new(label: "Dashboard",  path: root_path,     icon: :home, starts_with: "/")
  end

  def settings_items
    [
      NavItem.new(label: "Settings", path: user_settings_path, icon: :cog, starts_with: "/settings"),
    ]
  end

  def nav_active?(item)
    # root_path should only be active on exact "/"
    return request.path == "/" if item.path == root_path
    request.path.start_with?(item.starts_with)
  end

  def nav_item_classes(active)
    base = "group flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition"
    active ? "#{base} bg-gray-900 text-white shadow-sm" : "#{base} text-gray-700 hover:bg-gray-100"
  end

  def nav_icon_classes(active)
    base = "h-5 w-5 transition"
    active ? "#{base} text-white" : "#{base} text-gray-400 group-hover:text-gray-600"
  end
end
