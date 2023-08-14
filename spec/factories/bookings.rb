FactoryBot.define do
  factory :booking do
    name {Faker::Name.name}
    start_time {"10:00"}
    end_time {"11:00"}
    phone_number {Faker::PhoneNumber.phone_number_with_country_code}
    date_booking {Faker::Date.forward(days: 30)}
    total_cost {100000}
    association :football_pitch
    association :user
  end
end
