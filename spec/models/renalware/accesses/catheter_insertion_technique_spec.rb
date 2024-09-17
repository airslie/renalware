# frozen_string_literal: true

module Renalware
  module Accesses
    describe CatheterInsertionTechnique do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:code)
        is_expected.to validate_presence_of(:description)
      end
    end
  end
end
