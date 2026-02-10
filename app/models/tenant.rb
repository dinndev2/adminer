class Tenant < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :businesses
  has_many :bookings, through: :businesses
  has_many :services, through: :businesses
  has_many :users
  has_many :admins, -> { where(role: :admin) }, class_name: "User"
  enum :tier, [:free, :supercharged]
end
