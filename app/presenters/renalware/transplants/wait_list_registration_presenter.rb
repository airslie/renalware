module Renalware
  module Transplants
    class WaitListRegistrationPresenter < SimpleDelegator
      delegate :uk_transplant_centre, to: :document
      delegate :status, :status_updated_on, to: :uk_transplant_centre, prefix: true, allow_nil: true

      def uk_transplant_centre_summary
        return unless uk_transplant_centre_status.present?
        "#{uk_transplant_centre_status} (#{I18n.l(uk_transplant_centre_status_updated_on)})"
      end
    end
  end
end
