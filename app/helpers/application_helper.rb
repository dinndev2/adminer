module ApplicationHelper
  DEFAULT_IMAGE_FALLBACK = "image-fallback.svg".freeze

  def title
    "Adminer"
  end

  def image_tag(source, options = {})
    options = options&.dup || {}
    fallback = options.key?(:fallback) || options.key?("fallback") ? options.delete(:fallback) || options.delete("fallback") : DEFAULT_IMAGE_FALLBACK

    if source.blank? && fallback.present?
      source = fallback
      fallback = false
    end

    return super(source, options) unless fallback.present?

    options = options.stringify_keys
    fallback_handler = "this.onerror=null;this.src='#{asset_path(fallback)}';"
    options["onerror"] = [options["onerror"].presence, fallback_handler].compact.join(" ")

    super(source, options)
  end
end
