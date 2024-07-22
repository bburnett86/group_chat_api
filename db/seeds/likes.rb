100.times do
  loop do
    liker = User.all.sample
    liked = (User.all - [liker]).sample
    likeable = [Post.all.sample].compact.sample # Example for Post, add other likeable models if needed

    # Ensure likeable is present due to compact removing nil elements if Post.all.sample is nil
    next unless likeable

    like_exists = Like.exists?(
      liker_id: liker.id,
      liked_id: liked.id,
      likeable_type: likeable.class.to_s,
      likeable_id: likeable.id
    )

    unless like_exists
      Like.create!(
        liker: liker,
        liked: liked,
        likeable: likeable
      )
      break
    end
    # If the like relationship exists, the loop will continue to find a new pair
  end
end

50.times do
  loop do
    liker = User.all.sample
    liked = (User.all - [liker]).sample
    likeable = [Comment.all.sample].compact.sample 
		
    next unless likeable

    like_exists = Like.exists?(
      liker_id: liker.id,
      liked_id: liked.id,
      likeable_type: likeable.class.to_s,
      likeable_id: likeable.id
    )

    unless like_exists
      Like.create!(
        liker: liker,
        liked: liked,
        likeable: likeable
      )
      break
    end
  end
end

puts "Likes seeded."