class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def new?
    user
  end

  def create?
    new?
  end

  def update?
    user && (user.admin? || user.id == record.user_id)
  end

  def destroy?
    update?
  end
end
