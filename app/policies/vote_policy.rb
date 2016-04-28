module VotePolicy
  
  def like?
    user && user.id != record.user_id
  end

  def dislike?
    like?
  end

  def unvote?
    like?
  end

end
