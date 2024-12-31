module Renalware
  module Patients
    # Calculates a patients age. Takes into account:
    # - if they have a died_on date, in which case their age never changes
    # - which side of 'today' their birthday (e.g. May 11) falls, to make sure
    #   their age is for example only 99 and not 100 when their birthday is 100 years ago tomorrow,
    #   and 100 when its is 100 years ago today or yesterday.
    #
    # Example usage:
    #
    #   CalculateAge.for(patient) #=> 99
    #
    class CalculateAge
      pattr_initialize :patient
      delegate :born_on, :died_on, to: :patient

      def self.for(patient)
        new(patient).call
      end

      def call
        return if born_on.blank?

        age = relative_date.year - born_on.year
        age -= 1 if relative_date < (born_on + age.years) # for days before birthday
        age
      end

      private

      # Returns the effective date to measure up until, which will be their died_on if the patient
      # has one, otherwise today.
      def relative_date
        died_on || today
      end

      def today
        Time.now.utc.to_date
      end
    end
  end
end
