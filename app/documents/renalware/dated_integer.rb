module Renalware
  class DatedInteger < NestedAttribute
    attribute :result, Integer
    attribute :recorded_on, Date

    validates :recorded_on, timeliness: { type: :date, allow_blank: true }
    validates :recorded_on, presence: { if: -> { result.present? } }

    def to_s
      datestamp = recorded_on.present? ? "(#{I18n.l(recorded_on)})" : nil
      [result, datestamp].compact.join(" ")
    end
  end
end
