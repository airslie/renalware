module Renalware
  class BloodGroup < NestedAttribute
    attribute :group, Document::Enum
    attribute :rhesus, Document::Enum, enums: %i(positive negative)

    def to_s
      "#{group&.text} #{rhesus&.text}".strip
    end
  end
end
