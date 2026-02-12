class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :invitable
  enum :role, [:admin, :member] 
  belongs_to :tenant, optional: true
  
  has_many :owned_managements, class_name: 'Management', foreign_key: :member_id, dependent: :destroy
  has_many :admin_managements, class_name: 'Management', foreign_key: :admin_id, dependent: :destroy

  has_many :members, through: :admin_managements
  has_many :admins, through: :owned_managements

  has_many :bookings, dependent: :nullify
  has_many :businesses, through: :tenant

  validates :email, uniqueness: true
  validates :name, :role, presence: true


  has_one_attached :avatar

  def invited_by_tenant
    invited_by&.tenant
  end

  def personalized_bookings(business) 
    return Booking.none unless business
    scoped = if admin? 
      business.bookings
    else
      bookings.where(business_id: business.id) 
    end
  end

  def sorted_booking(bookings)
    s = { 
      "created" => {title: "Created", bookings: bookings.created },
      "not_finish" => {title: "Not Finish", bookings: bookings.not_finish },
      "finished" => {title: "Finished", bookings: bookings.finished }
    }
    s
  end
end

