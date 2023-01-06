# frozen_string_literal: true

module Renalware
  module Letters
    module QueryableLetter
      extend ActiveSupport::Concern
      included do
        def self.state_eq(state = :draft)
          where(type: Letter.state_class_name(state))
        end

        def self.clinic_visit_clinic_id_eq(clinic_id)
          joins("inner join clinic_visits on clinic_visits.id = letter_letters.event_id")
            .where(
              event_type: Renalware::Clinics::ClinicVisit.name,
              clinic_visits: { clinic_id: clinic_id }
            )
        end

        def self.finder_needs_type_condition?
          false
        end

        def self.ransackable_scopes(_auth_object = nil)
          %i(state_eq clinic_visit_clinic_id_eq)
        end

        ransacker :effective_date do
          effective_date_sort
        end
      end
    end

    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["effective_date desc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Letter.include(QueryableLetter).includes(:event).ransack(@q)
      end
    end
  end
end
