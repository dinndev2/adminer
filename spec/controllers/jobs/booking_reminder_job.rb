require "rails_helper"

RSpec.describe BookingReminderJob, type: :job do
  include ActiveJob::TestHelper

  let(:booking) { create(:booking, status: :not_finish, recurring: true) }

  it "sends reminder email and schedules recurring job" do
    expect {
      perform_enqueued_jobs { described_class.perform_now(booking.id) }
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
    
    
    expect(RecurringBookingJob).to have_been_enqueued.at(booking.to)
  end

  it "does nothing when booking is finished" do
    booking.update!(status: :finished)

    expect {
      perform_enqueued_jobs { described_class.perform_now(booking.id) }
    }.not_to change { ActionMailer::Base.deliveries.count }
  end
end
