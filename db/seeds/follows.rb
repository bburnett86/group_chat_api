25.times do
  loop do
    following_user = User.all.sample
    followed_user = (User.all - [following_user]).sample

    # Check if the follow relationship already exists
    follow_exists = Follow.exists?(following_user: following_user, followed_user: followed_user)

    # If it doesn't exist, create the follow relationship and break the loop
    unless follow_exists
      Follow.create!(
        following_user: following_user,
        followed_user: followed_user
      )
      break
    end
    # If the follow relationship exists, the loop will continue to find a new pair
  end
end

puts "Follows seeded."