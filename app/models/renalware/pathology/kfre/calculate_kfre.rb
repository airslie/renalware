module Renalware
  module Pathology
    module KFRE
      # Calculates the percentage chance of a patient developing kidney failure (eg 16.9%) based on
      # their age, sex, ACR (urine albumin) and EGFR (estimated glomerular filtration rate)
      # using the 4-variable KFRE, over 2 and 5 years.
      #
      # The equation is specified here:
      # https://www.nice.org.uk/guidance/ng203/chapter/recommendations#4-variable-kidney-failure-risk-equation
      # Online calculator:
      # https://www.kidney.org/professionals/kdoqi/gfr_calculator to verify.
      #
      # Some things to note about equation (reference above):
      # - log() here is equivalent to ln() or loge(), and not log10() which is what a calculator
      #   might give you when you click on log
      # - The last exponent line is a double exponent using e, so rather then using
      #   (x ^ sum) we need to use (x ^ Math.exp(sum)).
      #
      # Returns a KFREResult object containing 5 and 5 year re
      class CalculateKFRE
        include Callable
        attr_reader :sex, :age, :acr, :egfr

        UK_ADJUSTMENT_5_YR = 0.9570
        UK_ADJUSTMENT_2_YR = 0.9878

        def initialize(sex:, age:, acr:, egfr:)
          @sex = sex
          @age = age.to_i
          @acr = acr.to_f
          @egfr = egfr.to_f
        end

        # rubocop:disable Metrics/AbcSize
        def call
          return if insufficient_data?

          sum = (-0.2201 * ((age / 10.0) - 7.036)) +
                (0.2467 * (male - 0.5642)) -
                (0.5567 * ((egfr / 5.0) - 7.222)) +
                (0.4510 * (Math.log(acr / 0.113) - 5.137))

          KFRE::Result.new(
            yr2: ((1 - (UK_ADJUSTMENT_2_YR**Math.exp(sum))) * 100).round(1),
            yr5: ((1 - (UK_ADJUSTMENT_5_YR**Math.exp(sum))) * 100).round(1)
          )
        end
        # rubocop:enable Metrics/AbcSize

        private

        def insufficient_data?
          age.zero? || acr.zero? || egfr.zero? || sex.nil?
        end

        # Where the term 'male' is used, this should be replaced by a 1 if the person being
        # assessed is male, and a 0 if they are female.
        def male
          sex == "M" ? 1.0 : 0.0
        end
      end
    end
  end
end
