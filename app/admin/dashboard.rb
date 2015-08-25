ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.

    # columns do
    #   column do
    #     panel "Recent Leads" do
    #       ul do
    #         Lead.last(5).map do |lead|
    #           li link_to(lead.email, admin_lead_path(lead))
    #         end
    #       end
    #     end
    #   end
    #
    #   column do
    #     panel "Info" do
    #       para "Welcome to Perspectivo's Contacts Administration Page."
    #     end
    #   end
    # end
  end # content
end
