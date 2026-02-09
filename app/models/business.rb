class Business < ApplicationRecord
  belongs_to :tenant

  has_many :services, dependent: :destroy
  has_many :bookings, dependent: :destroy
end
