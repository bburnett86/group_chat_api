10.times do
  following_user = User.all.sample
  followed_user = (User.all - [following_user]).sample
  Follow.create!(
    following_user: following_user,
    followed_user: followed_user
  )
end