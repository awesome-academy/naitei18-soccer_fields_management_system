FactoryBot.define do
  factory :football_pitch_type do
    name {"Football pitch type #{Faker::Name.name}"}
    length {100}
    width {100}
  end
end
