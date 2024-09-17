# frozen_string_literal: true

module Renalware
  module Virology
    describe ProfileDocument, type: :model do
      it :aggregate_failures do
        is_expected.to respond_to(:hiv)
        is_expected.to respond_to(:hepatitis_b)
        is_expected.to respond_to(:hepatitis_b_core_antibody)
        is_expected.to respond_to(:hepatitis_c)
        is_expected.to respond_to(:htlv)
      end
    end
  end
end
