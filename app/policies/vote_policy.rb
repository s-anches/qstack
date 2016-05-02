module VotePolicy
  
  def can_vote?
    user && (user.id != record.user_id && !user.voted?(record))
  end

  def unvote?
    user && user.voted?(record)
  end

end
