FactoryBot.define do
  factory :business do
    association :tenant
    sequence(:name) { |n| "Business #{n}" }
    location { "Metro City" }
    description { "Sample business description" }
  end
end
