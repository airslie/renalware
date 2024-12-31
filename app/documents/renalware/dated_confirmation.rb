module Renalware
  class DatedConfirmation < NestedAttribute
    attribute :status, Document::Enum, enums: %i(yes no unknown)
    attribute :confirmed_on, Date

    validates :confirmed_on, timeliness: { type: :date, allow_blank: true }
    validates :confirmed_on, presence: true, if: ->(obj) { obj.status.try(:yes?) }

    def to_s
      datestamp = confirmed_on.present? ? "(#{I18n.l(confirmed_on)})" : nil
      [status.try(:text), datestamp].compact.join(" ")
    end
  end
end
