module Renalware
  module Pathology
    # This exercises a PostgreSQL function rather than a Ruby class.
    # rubocop:disable-next RSpec/DescribeClass
    describe "refresh_current_observation_set" do
      let(:patient) { create(:pathology_patient) }
      let(:request) { create(:pathology_observation_request, patient:) }
      let(:description) { create(:pathology_observation_description, code: "HGB") }
      let(:observed_at) { Time.zone.parse("2026-01-10 12:00:00") }

      def observation(**attributes)
        create(:pathology_observation, request:, description:, observed_at:, **attributes)
      end

      def refresh
        ApplicationRecord.connection.select_value(
          "SELECT refresh_current_observation_set(#{patient.id})"
        )
      end

      def snapshot
        CurrentObservationSet.find_by!(patient:)
      end

      it "rebuilds a missing snapshot with the latest result for each code" do
        observation(result: "120")
        observation(result: "110", observed_at: observed_at - 1.day)
        creatinine = create(:pathology_observation_description, code: "CRE")
        observation(description: creatinine, result: "80")
        snapshot.destroy!

        expect(refresh).to eq(patient.id)
        expect(snapshot.values.transform_values { it[:result] })
          .to eq("HGB" => "120", "CRE" => "80")
      end

      it "ignores newer empty results" do
        observation(result: "120")
        observation(result: "", observed_at: observed_at + 1.day)

        refresh

        expect(snapshot.values[:HGB][:result]).to eq("120")
      end

      it "uses London time in summer, matching the trigger across midnight" do
        observation(observed_at: Time.zone.parse("2026-05-10 00:00:00"))
        original_values = snapshot.values

        refresh

        expect(snapshot.values).to eq(original_values)
        expect(snapshot.values[:HGB][:observed_at]).to eq("2026-05-10T00:00:00")
      end

      it "prefers the later ID when observation and audit timestamps match" do
        observation(result: "120", created_at: observed_at, updated_at: observed_at)
        observation(result: "125", created_at: observed_at, updated_at: observed_at)

        refresh

        expect(snapshot.values[:HGB][:result]).to eq("125")
      end

      it "prefers a correction to an earlier row when observation timestamps match" do
        original = observation(result: "120", updated_at: observed_at)
        observation(result: "125", updated_at: observed_at + 1.hour)
        original.update!(result: "130", updated_at: observed_at + 2.hours)

        refresh

        expect(snapshot.values[:HGB][:result]).to eq("130")
      end

      it "removes deleted codes while preserving other patients and snapshot creation time" do
        observation(result: "120")
        creatinine = create(:pathology_observation_description, code: "CRE")
        observation(description: creatinine).delete
        other = create(:pathology_observation, description:, result: "999")
        other_snapshot = CurrentObservationSet.find_by!(patient_id: other.request.patient_id)
        other_values = other_snapshot.values
        snapshot.update!(created_at: observed_at, updated_at: observed_at)

        refresh

        expect(snapshot.values.keys).to eq(["HGB"])
        expect(snapshot.created_at).to eq(observed_at)
        expect(snapshot.updated_at).to be > observed_at
        expect(other_snapshot.reload.values).to eq(other_values)
      end

      it "clears the snapshot when every observation has been deleted" do
        observation.delete

        refresh

        expect(snapshot.values).to eq({})
      end

      it "clears the snapshot when only empty results remain" do
        observation.update!(result: "")

        refresh

        expect(snapshot.values).to eq({})
      end

      it "creates an empty snapshot for a patient without observations" do
        refresh

        expect(snapshot.values).to eq({})
      end
    end
  end
end
