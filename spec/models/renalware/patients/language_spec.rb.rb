# frozen_string_literal: true

module Renalware
  module Patients
    describe Language do
      it :aggregate_failures do
        is_expected.to validate_presence_of :name
        is_expected.to validate_presence_of :code
      end
    end
  end
end
