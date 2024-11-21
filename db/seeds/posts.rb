User.all.each do |user|
  10.times do
    Post.create!(
      description: Faker::Lorem.paragraph,
      user: user,
      close_friends: [true, false].sample,
    )
  end
end

puts "Posts seeded."