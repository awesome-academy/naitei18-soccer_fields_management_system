FactoryBot.define do
  factory :football_pitch do
    name {"#{Faker::Name.name}'s football pitch"}
    location {Faker::Address.full_address}
    price_per_hour {100000}
    association :football_pitch_type
  end
end
