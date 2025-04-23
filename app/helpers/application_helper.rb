module ApplicationHelper
    def admin_signed_in?
      admin_user_signed_in?
    end

    def admin?
      current_user&.role == 'admin'
    end
end
