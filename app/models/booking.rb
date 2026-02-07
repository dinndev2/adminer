class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :assigned_to, class_name: "User", foreign_key: :user_id, optional: true
  belongs_to :service

  validates :name, :from, :to, :user_id, presence: true
  enum :status, [:created, :not_finish, :finished]

  scope :created,    -> { where(status: :created).order(:position, :updated_at) }
  scope :not_finish, -> { where(status: :not_finish).order(:position, :updated_at) }
  scope :finished,   -> { where(status: :finished).order(:position, :updated_at) }

  private

  def customer_blank?(attrs)
    attrs.except(:_destroy).values.all?(&:blank?)
  end
end
 