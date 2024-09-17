# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR::Resources::TransferOfCare
      class Sections::MedicationsAndMedicalDevices < Sections::Base
        def snomed_code = "933361000000108"
        def title = "Medications and medical devices"

        # Reference to medication list?
        # entry: {
        #   reference: "urn:uuid:cef7f8d5-78e3-4866-89f1-62470d6fd636" # TODO
        # }
        def entries = []
      end
    end
  end
end
