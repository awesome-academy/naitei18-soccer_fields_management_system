FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {"Nguyenthaingoc1!"}
    role {1}
    trait :activated do
      activated {true}
      activated_at {Time.zone.now}
    end
  end
end
