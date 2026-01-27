class Booking < ApplicationRecord
  has_one :customer, dependent: :destroy
  belongs_to :user, optional: true

  validates :name, :description, :from, :to, presence: true
  enum :status, [:not_started, :in_progress, :delayed, :rejected, :finished]

  accepts_nested_attributes_for :customer, reject_if: :customer_blank?

  private

  def customer_blank?(attrs)
    attrs.except(:_destroy).values.all?(&:blank?)
  end
end
 