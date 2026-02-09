FactoryBot.define do
  factory :service do
    association :business
    sequence(:name) { |n| "Service #{n}" }
    description { "Service description" }
    price { 99.99 }
  end
end
