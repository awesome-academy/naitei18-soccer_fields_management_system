Create a main sample user.
User.create!(
  name: "Example User",
  email: "example@gmail.com",
  role: 1,
  password: "Nguyenthaingoc1!",
  password_confirmation: "Nguyenthaingoc1!",
  activated: true,
  activated_at: Time.zone.now
)


# Generate a bunch of additional users.
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gamil.com"
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

5.times do |n|
  name = "Sân bóng loại #{n}"
  length = n * 15
  width = n * 10
  FootballPitchType.create!(
    name: name,
    length: length,
    width: width
  )
end

30.times do |n|
  name = "Sân bóng số #{n}"
  location = Faker::Address.full_address
  price_per_hour = 100000
  football_pitch_type_id = (n % 5) + 1
  @football_pitch = FootballPitch.create!(
    name: name,
    location: location,
    price_per_hour: price_per_hour,
    football_pitch_type_id: football_pitch_type_id
  )
  @football_pitch.images.attach(io: File.open("/home/ngocnguyen/Desktop/images/image_1.jpg"), filename: "images_1.jpg", content_type: "image/jpeg")
  @football_pitch.images.attach(io: File.open("/home/ngocnguyen/Desktop/images/image_2.jpeg"), filename: "images_2.jpeg", content_type: "image/jpeg")
  @football_pitch.images.attach(io: File.open("/home/ngocnguyen/Desktop/images/image_3.jpg"), filename: "images_3.jpg", content_type: "image/jpeg")
  @football_pitch.save
end

users = User.all
football_pitches = FootballPitch.all
users.each do |user|
  football_pitches.each do |football_pitch|
    start_time = Faker::Number.between(from: 0, to: 23);
    end_time = Faker::Number.between(from: start_time + 1, to: 23);
    user.bookings.create!(
      name: user.name,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      date_booking: Faker::Date.forward(days: 30),
      start_time: "#{start_time}:00",
      end_time: "#{end_time}:00",
      total_cost: (end_time - start_time) * football_pitch.price_per_hour,
      football_pitch_id: football_pitch.id
    )
  end
end
