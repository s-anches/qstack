class QuestionPolicy < ApplicationPolicy
  include DefaultPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

end
