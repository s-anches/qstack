class QuestionPolicy < ApplicationPolicy
  include VotePolicy

  def subscribe?
    user && !user.subscribed?(record)
  end

  def unsubscribe?
    user && user.subscribed?(record)
  end
end
