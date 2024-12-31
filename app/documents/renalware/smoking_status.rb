module Renalware
  class SmokingStatus < NestedAttribute
    SMOKING_SNOMED_MAP = {
      current: { code: 77176002, description: "Current" },
      non_smoker: { code: 8392000, description: "Non" },
      ex_smoker: { code: 8517006, description: "Ex" }
    }.freeze

    attribute :value,
              Document::Enum,
              enums: %i(non_smoker ex_smoker current)

    def snomed_code
      SMOKING_SNOMED_MAP.dig(value&.to_sym, :code)
    end

    def snomed_description
      SMOKING_SNOMED_MAP.dig(value&.to_sym, :description)
    end
  end
end
