# frozen_string_literal: true

module Renalware
  module HD
    class PrescriptionLastAdministrationComponent < ApplicationComponent
      pattr_initialize [:prescription!]

      def last_administration
        return if prescription.blank?

        @last_administration ||=
          PrescriptionLastAdministrationQuery.call(prescription: prescription)
      end

      def render?
        last_administration.present?
      end
    end
  end
end
