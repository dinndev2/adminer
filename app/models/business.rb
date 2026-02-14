class Business < ApplicationRecord
  belongs_to :tenant

  has_many :services, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :admins, through: :tenant

  validates :name, :website, presence: true
  validate :website_is_valid

  has_one_attached :logo


  private

  def website_is_valid
    return if website.blank?
    uri = URI.parse(website)
    errors.add(:website, "is invalid") unless uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    errors.add(:website, "is invalid")
  end
end  
