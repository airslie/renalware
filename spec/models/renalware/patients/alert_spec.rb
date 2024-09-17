# frozen_string_literal: true

module Renalware
  module Patients
    describe Alert do
      it_behaves_like "a Paranoid model"
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:notes)
        is_expected.to validate_presence_of(:patient)
        is_expected.to belong_to(:patient).touch(true)
      end
    end
  end
end
