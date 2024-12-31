module Renalware
  module Pathology
    # Responsible for converting a collection of observations dates to a range.
    #
    class ObservationDateRange
      def self.build(values)
        # Must add a day to the range to cover observations that occur on the
        # same day after midnight. e.g. if we want observations up to
        # 2010-01-01 then we also want observations with the time stamp
        # 2010-01-01 10:30. If we don't add a day to the range then this
        # observation  will be omitted
        #

        Range.new(values.first, values.last + 1.day) if values.any?
      end
    end
  end
end
