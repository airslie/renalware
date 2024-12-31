module Renalware
  module PatientHelper
    # Note we use a stimulus controller to highlight the menu items in places where the wrapping
    # nav specifies that controller, which allows cache the menu partials. In other places we
    # just rely on this helper executing and adding the active class.
    # Its possible in places that the active class is added by both this helper and the js...
    def patient_menu_item(title:, path:, active_when_controller_matches:, enabled: true)
      klasses = %w(link)
      klasses << "active" if current_controller_matches(active_when_controller_matches)
      tag.li(
        class: klasses.join(" "),
        "data-navbar-target": "nav",
        "data-rails-controller": active_when_controller_matches
      ) do
        if enabled
          link_to(title, path)
        else
          tag.span title
        end
      end
    end

    def current_controller_matches(regex)
      regex.match(params[:controller]).present?
    end

    def formatted_nhs_number(patient)
      ::Renalware::PatientPresenter.new(patient).nhs_number
    end
  end
end
