module Renalware
  module Medications
    class Review < Events::Event
      belongs_to :patient
      DEFAULT_MAX_AGE_IN_MONTHS = 24

      def self.latest
        max_age_in_months = Renalware.config.medication_review_max_age_in_months.to_i
        max_age_in_months = DEFAULT_MAX_AGE_IN_MONTHS if max_age_in_months.zero?
        where("date_time::date >= ?", max_age_in_months.months.ago).order(date_time: :desc).first
      end

      def partial_for(partial_type)
        File.join("renalware/medications/reviews", partial_type)
      end
    end
  end
end
