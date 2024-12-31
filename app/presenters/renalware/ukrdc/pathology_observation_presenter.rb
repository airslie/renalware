module Renalware
  module UKRDC
    # Assumes the thing being passed to the ctor is of type Pathology::ObservationPresenter hence
    # responds to #description_code
    class PathologyObservationPresenter < SimpleDelegator
      delegate :rr_type_interpretation?, to: :description

      INTERPRETATION_CODE_MAP = {
        "positive" => "POS",
        "negative" => "NEG"
      }.freeze
      DEFAULT_INTERPRETATION_CODE = "UNK".freeze

      # The PrePost element in ResultItem
      # For HD patients, all bloods are PRE except the post dialysis urea,
      # For non-HD patients, all the tests are NA
      def pre_post(patient_is_on_hd:)
        if patient_is_on_hd
          description_code.casecmp("UREP").zero? ? "POST" : "PRE"
        else
          "NA"
        end
      end

      # Truncate long result text to satisfy XSD validation - it might be notes
      # like eg "No recent Urea result"
      def result
        (super || "")[0..19]
      end

      def coding_standard
        return if description_rr_coding_standard.blank?

        description_rr_coding_standard.to_s.upcase
      end

      def code
        description_loinc_code.presence || description_code
      end

      def interpretation_code
        sanitized_result = result&.downcase&.strip

        INTERPRETATION_CODE_MAP.fetch(sanitized_result, DEFAULT_INTERPRETATION_CODE)
      end
    end
  end
end
