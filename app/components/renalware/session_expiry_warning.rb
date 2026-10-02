# frozen_string_literal: true

# Shown by session_controller.js shortly before the user's session expires.
class Renalware::SessionExpiryWarning < Shared::Base
  def view_template
    dialog(**dialog_attrs) do
      div(class: "px-6 py-5") do
        title
        description
        actions
      end
    end
  end

  private

  def dialog_attrs
    {
      class: "rounded-md shadow-xl p-0 w-full max-w-md",
      role: "alertdialog",
      aria: { labelledby: "session-expiry-warning-title",
              describedby: "session-expiry-warning-description" },
      data: { session_target: "warningDialog", action: "cancel->session#staySignedIn" }
    }
  end

  def title
    h2(id: "session-expiry-warning-title", class: "text-lg font-semibold mb-3") do
      "Your session is about to expire"
    end
  end

  def description
    p(id: "session-expiry-warning-description", class: "mb-5") do
      plain "You will be logged out in "
      strong(data: { session_target: "countdown" }) { "2:00" }
      plain " because you have been inactive. Anything you have not saved will be lost."
    end
  end

  def actions
    div(class: "flex justify-end gap-3") do
      log_out_link
      button(type: "button", class: "btn btn-primary", autofocus: true,
             data: { action: "session#staySignedIn" }) { "Stay signed in" }
    end
  end

  def log_out_link
    a(href: destroy_user_session_path,
      class: "btn btn-secondary",
      data: { method: "delete", action: "click->session#sendLogoutMessageToAnyOpenTabs" }) do
      "Log out"
    end
  end
end
