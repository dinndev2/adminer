FactoryBot.define do
  factory :user do
    association :tenant
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
    role { :member }
    password { "password123" }
    password_confirmation { "password123" }

    trait :admin do
      role { :admin }
    end
  end
end
