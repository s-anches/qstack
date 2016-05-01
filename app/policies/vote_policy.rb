module VotePolicy
  
  def like?
    user && user.id != record.user_id && !user.voted?
  end

  def dislike?
    like?
  end

  def unvote?
    user.voted?
  end

end
