# frozen_string_literal: true

module Renalware
  describe HD::Patient do
    it { is_expected.to have_many(:prescription_administrations) }
    it { is_expected.to have_many(:vnd_risk_assessments) }
  end
end
