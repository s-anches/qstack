class ApiPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user
  end

  def show?
    user
  end

  def create?
    user
  end

  def me?
    index?
  end

end
