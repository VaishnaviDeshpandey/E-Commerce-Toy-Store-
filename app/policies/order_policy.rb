class OrderPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def index?
    user.user?
  end

  def admin_index?
    user.admin?
  end

  def show?
    user.admin? || record.user == user
  end

  def create?
    user.present? && user.user?
  end


  def confirm_payment?
    user.admin?
  end

  def update?
    user.admin?
  end

  def thank_you?
    user.present? && record.user == user  # Allow only the order owner to view
  end

  def destroy?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
