module DefaultPolicy
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