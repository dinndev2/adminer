class Management < ApplicationRecord
  belongs_to :admin, class_name: 'User'
  belongs_to :member, class_name: 'User'
end
