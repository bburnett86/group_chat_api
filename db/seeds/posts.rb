User.all.each do |user|
  5.times do
    Post.create!(
      description: Faker::Lorem.paragraph,
      user: user,
      close_friends: [true, false].sample
    )
  end
end