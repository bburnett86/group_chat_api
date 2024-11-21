require 'faker'

10.times do
  unique_name = nil
  loop do
    proposed_name = Faker::Company.unique.name
    unless Club.exists?(name: proposed_name)
      unique_name = proposed_name
      break
    end
  end

  club = Club.create!(
    name: unique_name,
    about_us: Faker::Lorem.paragraph(sentence_count: 2),
    public: [true, false].sample
  )

  # Assuming you have a User model and at least 10 users
  users = User.all.sample(10)

  users.each do |user|
    Participant.create!(
      user_id: user.id,
      participable: club,
      status: ["PENDING", "ACCEPTED", "REJECTED", "MAYBE"].sample, # Randomly assign a status
      role: ["MEMBER", "ADMIN", "SUPERADMIN"].sample # Randomly assign a role
    )
  end
end

puts "Clubs seeded"