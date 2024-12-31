module Renalware
  class DatedResult < NestedAttribute
    attribute :result
    attribute :recorded_on, Date

    validates :recorded_on, timeliness: { type: :date, allow_blank: true }

    def to_s
      datestamp = recorded_on.present? ? "(#{I18n.l(recorded_on)})" : nil
      [result, datestamp].compact.join(" ")
    end
  end
end
