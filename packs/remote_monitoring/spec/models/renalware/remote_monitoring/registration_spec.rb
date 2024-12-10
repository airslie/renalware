# frozen_string_literal: true

module Renalware
  RSpec.describe RemoteMonitoring::Registration do
    it { is_expected.to be_a(Events::Event) }

    describe RemoteMonitoring::Registration::Document do
      describe "validation" do
        it :aggregate_failures do
          is_expected.to validate_numericality_of(:baseline_creatinine)
          is_expected.to validate_presence_of(:frequency_iso8601)
        end
      end
    end
  end
end
