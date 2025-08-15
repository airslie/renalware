module Renalware
  module Letters
    describe Topic do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of :text }
      it { is_expected.to belong_to(:snomed_document_type) }
    end
  end
end
