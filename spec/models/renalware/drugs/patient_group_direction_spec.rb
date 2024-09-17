# frozen_string_literal: true

module Renalware
  module Drugs
    describe PatientGroupDirection do
      it { is_expected.to validate_presence_of :name }
    end
  end
end
