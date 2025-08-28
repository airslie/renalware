module Renalware
  module Letters::SectionIdentifier
    extend ActiveSupport::Concern

    included do
      validates(
        :section_identifier,
        inclusion: { in: LETTER_SECTION_IDENTIFIERS.map(&:to_s), allow_nil: true }
      )
    end
  end
end
