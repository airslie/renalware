module Renalware
  module Patients
    class PracticeSearchQuery
      attr_reader :search_term

      def initialize(search_term:)
        @search_term = search_term
      end

      def call
        return [] if search_term.blank?

        term = "%#{search_term}%"
        Practice
          .select(:id, :name, :code)
          .left_outer_joins(:address)
          .includes(:address)
          .where("patient_practices.name ILIKE ? " \
                 "OR patient_practices.code = ? " \
                 "OR addresses.street_1 ILIKE ? " \
                 "OR addresses.postcode ILIKE ?", term, search_term, term, term)
          .where(active: true)
          .limit(50)
      end
    end
  end
end
