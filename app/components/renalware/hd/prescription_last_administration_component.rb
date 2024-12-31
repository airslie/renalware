module Renalware
  module HD
    class PrescriptionLastAdministrationComponent < ApplicationComponent
      pattr_initialize [:prescription!]

      def last_administration
        return if prescription.blank?

        @last_administration ||=
          PrescriptionAdministrationsQuery.call(prescription: prescription).first
      end

      def render?
        last_administration.present?
      end
    end
  end
end
