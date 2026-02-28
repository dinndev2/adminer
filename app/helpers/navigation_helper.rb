require "digest"

module NavigationHelper
  NAV_ITEM_BASE_CLASSES = "group flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition".freeze
  NAV_ITEM_ACTIVE_CLASSES = "#{NAV_ITEM_BASE_CLASSES} bg-gray-900 text-white shadow-sm".freeze
  NAV_ITEM_INACTIVE_CLASSES = "#{NAV_ITEM_BASE_CLASSES} text-gray-700 hover:bg-gray-100".freeze
  NAV_ICON_BASE_CLASSES = "h-5 w-5 transition".freeze
  NAV_ICON_ACTIVE_CLASSES = "#{NAV_ICON_BASE_CLASSES} text-white".freeze
  NAV_ICON_INACTIVE_CLASSES = "#{NAV_ICON_BASE_CLASSES} text-gray-400 group-hover:text-gray-600".freeze
  NavItem = Struct.new(:label, :path, :icon, :starts_with, keyword_init: true)

  def nav_items(business)
    [
      NavItem.new(label: "Information", path: business_path(business),         icon: :briefcase, starts_with: "/businesses/#{business.id}"),
      NavItem.new(label: "Bookings",    path: business_bookings_path(business), icon: :calendar,  starts_with: "/businesses/#{business.id}/bookings"),
      NavItem.new(label: "Services",    path: business_services_path(business), icon: :tag,       starts_with: "/businesses/#{business.id}/services"),
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


  def nav_active?(item, exact: false)
    return request.path == item.path if exact
    return request.path == "/" if item.path == root_path
    request.path.start_with?(item.starts_with)
  end
  

  def nav_item_classes(active)
    active ? NAV_ITEM_ACTIVE_CLASSES : NAV_ITEM_INACTIVE_CLASSES
  end

  def nav_icon_classes(active)
    active ? NAV_ICON_ACTIVE_CLASSES : NAV_ICON_INACTIVE_CLASSES
  end

  def nav_link_data(item, exact: false)
    {
      nav_item: true,
      nav_exact: exact,
      nav_path: item.path,
      nav_starts_with: item.starts_with,
      nav_active_class: NAV_ITEM_ACTIVE_CLASSES,
      nav_inactive_class: NAV_ITEM_INACTIVE_CLASSES
    }
  end

  def nav_icon_data
    {
      nav_icon: true,
      nav_active_class: NAV_ICON_ACTIVE_CLASSES,
      nav_inactive_class: NAV_ICON_INACTIVE_CLASSES
    }
  end

  def navigation_version_key
    parts = [
      @tenant&.cache_key_with_version,
      @businesses&.size,
      @businesses&.maximum(:updated_at)&.utc&.to_i
    ]

    Digest::SHA1.hexdigest(parts.compact.join("/"))
  end

  def top_nav_version_key
    parts = [
      current_user&.cache_key_with_version,
      @tenant&.cache_key_with_version,
      @tenant&.supercharged?
    ]

    Digest::SHA1.hexdigest(parts.compact.join("/"))
  end
end
