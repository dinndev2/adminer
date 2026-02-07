class Tenant < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true
  validates :name, uniqueness: true
end
