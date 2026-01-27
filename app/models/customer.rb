class Customer < ApplicationRecord
  belongs_to :booking, optional: true
end