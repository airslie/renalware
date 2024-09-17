# frozen_string_literal: true

require_relative "shared_examples"

module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::LegalInformationComponent, type: :component do
      it_behaves_like "a not yet implemented ToC section"
    end
  end
end
