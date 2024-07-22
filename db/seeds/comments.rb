user_ids = User.pluck(:id)

Post.all.each do |post|
  5.times do
    Comment.create!(
      description: Faker::Lorem.paragraph,
      user_id: user_ids.sample,
			post: post,
    )
  end
end

puts "Comments seeded."