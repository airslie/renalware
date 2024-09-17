# frozen_string_literal: true

module Renalware
  module Pathology
    describe CurrentObservationsForDescriptionsQuery do
      include PathologySpecHelper
      describe "#call" do
        let(:patient) { create_patient }

        it "returns observations for the specified descriptions" do
          descriptions = create_descriptions(%w(target-1 exclude target-2))
          create_observations(patient, descriptions)
          target_descriptions = filter_targeted_descriptions(descriptions)

          query = described_class.new(
            patient: patient, descriptions: target_descriptions
          )
          results = query.call

          expect(results.map(&:description_name)).to match_array(%w(target-1 target-2))
        end

        it "returns the null observations for descriptions not yet observed" do
          missing_descriptions = add_descriptions_not_observed_for_patient("missing-1", "missing-2")

          query = described_class.new(
            patient: patient, descriptions: missing_descriptions
          )
          results = query.call

          expect(results.map(&:description_name)).to match_array(%w(missing-1 missing-2))
        end

        it "returns the unique observation for the specified description" do
          descriptions = create_descriptions(%w(target-1))
          create_observations(patient, descriptions)
          create_observations(patient, descriptions)

          query = described_class.new(
            patient: patient, descriptions: descriptions
          )
          results = query.call

          expect(results.map(&:description_name)).to match_array(%w(target-1))
        end
      end

      def add_descriptions_not_observed_for_patient(*description_names)
        description_names.map { |name| create_observation_description(name) }
      end

      def filter_targeted_descriptions(descriptions)
        descriptions.select { |description| description.name.start_with?("target-") }
      end
    end
  end
end
