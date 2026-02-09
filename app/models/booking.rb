class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :assigned_to, class_name: "User", foreign_key: :user_id, optional: true
  belongs_to :service
  belongs_to :business

  validates :name, :from, :to, :user_id, presence: true
  enum :status, [:created, :not_finish, :finished]

  scope :created,    -> { where(status: :created).order(:position, :updated_at) }
  scope :not_finish, -> { where(status: :not_finish).order(:position, :updated_at) }
  scope :finished,   -> { where(status: :finished).order(:position, :updated_at) }
  scope :today, -> {
    d = Date.current
    where("bookings.from <= ? AND bookings.to >= ?", d, d)
  }

  scope :this_week, -> {
    range = Date.current.beginning_of_week..Date.current.end_of_week
    where(from: range).or(where(to: range))
  }

  scope :ending_this_week, -> {
    range = Date.current.beginning_of_week..Date.current.end_of_week
    where(to: range).where.not(status: :finished)
  }

  before_create :set_position

  private

  def customer_blank?(attrs)
    attrs.except(:_destroy).values.all?(&:blank?)
  end
  
  def set_position
    self.position ||= (Booking.where(status: status).maximum(:position) || -1) + 1
  end
end
 