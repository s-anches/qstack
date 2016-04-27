class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def create?
    user
  end

  def update?
    user && (user.admin? || user.id == record.user_id)
  end

  def destroy?
    update?
  end

  def set_best?
    user && user.id == record.question.user_id
  end


end
