10.times do
  username = Faker::Internet.username
  while username.length < 5
    username = Faker::Internet.username
  end

  User.create!(
    email: Faker::Internet.email,
    password: Devise::Encryptor.digest(User, 'password'),
    username: username,
    bio: Faker::Lorem.sentence,
    role: 'STANDARD',
    active: true,
		avatar_url: Faker::LoremFlickr.image
  )
end