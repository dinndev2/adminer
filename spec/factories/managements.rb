FactoryBot.define do
  factory :management do
    association :admin, factory: [:user, :admin]
    association :member, factory: :user
  end
end
