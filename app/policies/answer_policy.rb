class AnswerPolicy < ApplicationPolicy
  include VotePolicy
  
  def set_best?
    user && user.id == record.question.user_id
  end

end
