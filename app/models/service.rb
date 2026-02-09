class Service < ApplicationRecord
  has_many :bookings, dependent: :destroy
  validates :name, presence: true
  belongs_to :business
end
