class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    record == user
    # - record: the user passed to the `authorize` method in controller
    # - user:   the `current_user` signed in with Devise.
  end

  def deactivate?
    record == user
  end
end
