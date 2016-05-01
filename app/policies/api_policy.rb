class ApiPolicy < ApplicationPolicy

  attr_reader :user

  def initialize(user)
    @user = user
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user
  end

  def me?
    user
  end

end
