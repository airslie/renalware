module Renalware
  module Pathology
    describe CurrentObservation do
      include PathologySpecHelper
      it { is_expected.to belong_to(:patient) }

      describe "#all" do
        it "returns only the most recent path results" do
          patient = create_patient
          descriptions = create_descriptions(%w(x y z))
          freeze_time do
            # current
            create_observations(patient,
                                descriptions,
                                observed_at: Time.zone.now,
                                result: 99)
            # not current
            create_observations(patient,
                                descriptions,
                                observed_at: 1.day.ago,
                                result: 1)

            obs = patient.current_observations.all

            expect(obs.length).to eq(3)
            expect(obs.map(&:observed_at).uniq).to eq([Time.zone.now])
            expect(obs.map(&:result).uniq).to eq(["99"])
          end
        end
      end
    end
  end
end
