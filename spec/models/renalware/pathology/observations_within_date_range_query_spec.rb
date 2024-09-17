# frozen_string_literal: true

module Renalware
  module Pathology
    describe ObservationsWithinDateRangeQuery do
      describe "#call" do
        it "returns the observation for the specified range" do
          patient = create_patient

          create_observations_observed_at(
            patient, "2014-01-01", "2016-01-01", "2015-01-01", "2016-01-01", "2013-01-1"
          )

          query = described_class.new(
            date_range: Range.new("2014-01-01", "2016-01-01")
          )
          records = query.call

          expect(records.map(&extract_observed_on)).to \
            match_array(%w(2016-01-01 2016-01-01 2015-01-01 2014-01-01))
        end
      end

      def extract_observed_on
        ->(record) { record.observed_at.strftime("%Y-%m-%d") }
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
