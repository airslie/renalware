module Renalware
  class DatedBooleanDiagnosis < NestedAttribute
    attribute :diagnosis, Boolean
    attribute :diagnosed_on, Date

    validates :diagnosed_on, timeliness: { type: :date, allow_blank: true }

    def to_s
      return "" if diagnosis.to_s.blank?

      datestamp = diagnosed_on.present? ? "(#{I18n.l(diagnosed_on)})" : nil
      [(diagnosis ? "Yes" : "No"), datestamp].compact.join(" ")
    end
  end
end
