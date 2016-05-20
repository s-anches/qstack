class QuestionPolicy < ApplicationPolicy
  include VotePolicy

  def subscribe?
    user && user.id != record.user_id && !user.subscribed?(record)
  end

  def unsubscribe?
    user && user.id != record.user_id && user.subscribed?(record)
  end
end
