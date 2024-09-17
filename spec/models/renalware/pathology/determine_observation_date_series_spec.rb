# frozen_string_literal: true

module Renalware
  module Pathology
    describe DetermineObservationDateSeries do
      describe "#call" do
        it "returns the range for the specified limit" do
          patient = create_patient
          create_observations_observed_at(
            patient, "2014-01-01", "2016-01-01", "2015-01-01", "2016-01-01", "2013-01-01"
          )

          query = described_class.new
          actual_series = query.call

          expected_series = [
            date("2016-01-01"),
            date("2015-01-01"),
            date("2014-01-01"),
            date("2013-01-01")
          ]
          expect(actual_series).to eq(expected_series)
        end
      end

      def date(string)
        Date.parse(string)
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations_observed_at(patient, *observation_dates)
        observation_dates.each do |observed_on|
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, observed_at: observed_on)
        end
      end
    end
  end
end
