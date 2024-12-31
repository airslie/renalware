module Renalware
  module Letters::Formats::FHIR::Resources::TransferOfCare::Sections
    class SectionComponent < ApplicationComponent
      pattr_initialize :letter
      delegate :patient, to: :letter, allow_nil: true
    end
  end
end
