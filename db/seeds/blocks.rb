10.times do
  user = User.all.sample
  blocked_user = (User.all - [user]).sample
  Block.create!(
    user: user,
    blocked_user: blocked_user
  )
end