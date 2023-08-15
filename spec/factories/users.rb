FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {"Nguyenthaingoc1!"}
    trait :activated do
      activated {true}
      activated_at {Time.zone.now}
    end

    trait :admin do
      role {1}
    end

    trait :not_admin do
      role {0}
    end
  end
end
