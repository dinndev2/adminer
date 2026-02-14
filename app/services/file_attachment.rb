class FileAttachment
  require 'open-uri'

  def initialize(file_url, record)
    @record = record
    @url = file_url
  end

  def call
    io = URI.open(@url, "User-Agent" => "Mozilla/5.0", read_timeout: 8)
    content_type = io.content_type || "image/png" 
    filename = filename_from_url(@url)
    @record.logo.attach(
      io: io,
      filename: filename,
      content_type: content_type
    )
    @record.save
    rescue => e
      Rails.logger.warn("FileAttachment failed: #{e.class} #{e.message}")
    false
  end

  def filename_from_url(url)
    path = URI.parse(url).path
    base = File.basename(path)
    base.present? && base != "/" ? base : "logo.png"
  rescue
    "logo.png"
  end
end