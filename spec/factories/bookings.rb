FactoryBot.define do
  factory :booking do
    association :business
    association :customer
    assigned_to { association(:user, tenant: business.tenant) }
    service { association(:service, business: business) }

    sequence(:name) { |n| "Booking #{n}" }
    description { "Booking description" }
    from { Date.current }
    to { Date.current + 1.day }
    duration { 60 }
    status { :created }
  end
end
