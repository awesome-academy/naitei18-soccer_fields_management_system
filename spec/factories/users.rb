FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {"Nguyenthaingoc1!"}
    role {1}
  end
end
