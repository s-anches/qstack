class CommentPolicy < ApplicationPolicy
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

  def destroy?
    user && (user.admin? || user.id == record.user_id)
  end
end
