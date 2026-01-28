class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable
  enum :role, [:admin, :member] 
  
  has_many :owned_managements, class_name: 'Management', foreign_key: :member_id
  has_many :admin_managements, class_name: 'Management', foreign_key: :admin_id

  has_many :members, through: :admin_managements
  has_many :admins, through: :owned_managements

  has_many :bookings

  validates :email, uniqueness: true
end
