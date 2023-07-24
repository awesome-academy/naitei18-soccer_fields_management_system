# Create a main sample user.
User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  role: 1,
  password: "Nguyenthaingoc1!",
  password_confirmation: "Nguyenthaingoc1!",
  activated: true,
  activated_at: Time.zone.now
)


# Generate a bunch of additional users.
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "Nguyenthaingoc1!"
  User.create!(
    name: name,
    email: email,
    role: 0,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end
