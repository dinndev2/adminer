FactoryBot.define do
  factory :tenant do
    sequence(:name) { |n| "Tenant #{n}" }
    description { "Sample tenant description" }
    website { "https://example.com" }
    industry { "Booking Services" }
    company_size { "1-5" }
    color { "#111827" }
  end
end
