5.times do
	start_time = Faker::Time.between(from: DateTime.now, to: DateTime.now + 23)
  end_time = start_time + rand(1..6).hours

  event = Event.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    start_time: start_time,
    end_time: end_time,
    active: true
  )

  # Assuming you have at least 10 users in your database
  users = User.all.sample(10)

  users.each do |user|
    Participant.create!(
      user_id: user.id,
      participable: event,
      status: ["PENDING", "ACCEPTED", "REJECTED", "MAYBE"].sample, # Randomly assign a status
      role: ["MEMBER", "ADMIN", "SUPERADMIN"].sample # Randomly assign a role
    )
  end
end

puts "Events seeded."