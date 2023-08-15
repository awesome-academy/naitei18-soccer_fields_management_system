FactoryBot.define do
  factory :review do
    comment {"Good!"}
    rating {5}
    association :football_pitch
    association :user
  end
end
