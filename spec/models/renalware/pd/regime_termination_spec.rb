# frozen_string_literal: true

module Renalware
  module PD
    describe RegimeTermination do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_timeliness_of :terminated_on
        is_expected.to belong_to(:regime).touch(true)
      end
    end
  end
end
