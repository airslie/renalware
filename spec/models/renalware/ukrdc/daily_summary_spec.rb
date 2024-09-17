# frozen_string_literal: true

module Renalware
  describe UKRDC::DailySummary do
    it { is_expected.to respond_to(:date) } # sanmity check!
  end
end
