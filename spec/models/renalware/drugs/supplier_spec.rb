# frozen_string_literal: true

module Renalware
  module Drugs
    describe Supplier do
      it { is_expected.to validate_presence_of :name }
    end
  end
end
