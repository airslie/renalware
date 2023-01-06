# frozen_string_literal: true

module Renalware
  module Medications
    class RouteFormPresenter < DumbDelegator
      def code
        ::I18n.t(
          super.downcase,
          scope: "medications.routes.form.prompt",
          default: super
        )
      end
    end
  end
end
