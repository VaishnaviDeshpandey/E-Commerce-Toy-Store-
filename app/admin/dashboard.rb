# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    
    # Custom message
    panel "Admin Announcement" do
      para "Welcome to the Admin Dashboard. Keep track of orders, users, and system stats here."
    end

    # Example of columns layout
    columns do
      column do
        panel "Recent Orders" do
          para "This section will display your latest orders soon."
        end
      end

      column do
        panel "Quick Info" do
          para "Helpful reminders or system updates can go here."
        end
      end
    end
  end
end
