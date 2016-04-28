class AnswerPolicy < ApplicationPolicy
  include DefaultPolicy
  
  class Scope < Scope
    def resolve
      scope
    end
  end

  def set_best?
    user && user.id == record.question.user_id
  end

end
