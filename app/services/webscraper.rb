class Webscraper 
  require 'nokogiri'
  require 'open-uri'

  def initialize(link)
    @link = normalize_url(link)
  end


  def call
    html = URI.open(@link, read_timeout: 5).read
    doc  = Nokogiri::HTML(html)
     
    {
      name: doc.at('title')&.text,
      description: doc.at('meta[name="description"]')&.[]('content'),
      logo: doc.at('meta[property="og:image"]')&.[]('content')
    }
  rescue
    {}
  end

  private

  def normalize_url(url)
    url.start_with?("http") ? url : "https://#{url}"
  end
end