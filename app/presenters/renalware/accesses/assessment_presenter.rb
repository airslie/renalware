module Renalware
  module Accesses
    class AssessmentPresenter < DumbDelegator
      def performed_on
        ::I18n.l(super)
      end

      def procedure_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end

      def outcome
        document.results.outcome.try(:text)
      end

      def next_surveillance
        document.admin.next_surveillance.try(:text)
      end

      def decision
        document.admin.decision
      end
    end
  end
end
