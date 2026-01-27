class Service < ApplicationRecord
  belongs_to :booking, optional: true

  validates :name, presence: true
end
