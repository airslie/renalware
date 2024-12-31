module Renalware
  class DatedTest < NestedAttribute
    attribute :result, Document::Enum, enums: %i(negative positive not_done)
    attribute :recorded_on, Date

    validates :recorded_on, timeliness: { type: :date, allow_blank: true }

    def to_s
      datestamp = recorded_on.present? ? "(#{I18n.l(recorded_on)})" : nil
      [result.try(:text), datestamp].compact.join(" ")
    end
  end
end
