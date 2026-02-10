require 'rails_helper'

RSpec.describe BookingCreation do

  describe '#set' do
    it 'saves booking and triggers notification' do
      tenant = create(:tenant)
      business = create(:business, tenant: tenant)
      assigned_to = create(:user, tenant: tenant)
      booking = build(:booking, business: business, assigned_to: assigned_to)
      notification = instance_double(BookingNotification, booked!: true)

      expect(BookingNotification).to receive(:new).with(booking).and_return(notification)
      expect(notification).to receive(:booked!)

      result = described_class.new(booking).set
      
      
      expect(result.success?).to be(true)
      expect(result.record).to eq(booking)
      expect(booking).to be_persisted
    end

    it 'returns errors when booking is invalid and does not notify' do
      booking = build(:booking, name: nil)

      expect(BookingNotification).not_to receive(:new)

      result = described_class.new(booking).set

      expect(result.success?).to be(false)
      expect(result.errors).to be_present
      expect(booking).not_to be_persisted
    end
  end
end
