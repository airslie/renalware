module Renalware
  module Pathology
    describe ObservationsForDescriptionsQuery do
      describe "#call" do
        it "returns the patient's observations for the specified descriptions" do
          patient = create_patient

          descriptions = create_observations_with_descriptions(
            patient, "target-1", "exclude", "target-2"
          )
          target_descriptions = filter_targeted_descriptions(descriptions)

          query = described_class.new(descriptions: target_descriptions)
          results = query.call

          expect(results.map(&description_codes)).to match_array(%w(target-1 target-2))
        end
      end

      def description_codes
        ->(observation) { observation.description.code }
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations_with_descriptions(patient, *description_codes)
        description_codes.map do |code|
          description = create(:pathology_observation_description, code: code)
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, description: description)

          description
        end
      end

      def filter_targeted_descriptions(descriptions)
        descriptions.select { |description| description.code.start_with?("target-") }
      end
    end
  end
end
