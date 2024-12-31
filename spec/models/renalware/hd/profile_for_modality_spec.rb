module Renalware
  module HD
    describe ProfileForModality do
      describe "#hd_profile_id" do
        subject(:resolved_profile_id) do
          described_class.find_by!(modality_id: modality.id).hd_profile_id
        end

        let(:user) { create(:user) }
        let(:patient) { create(:hd_patient) }
        let(:hd_modality_description) { create(:hd_modality_description) }
        let(:modality_started_on) { 1.week.ago }
        let(:modality) do
          create(
            :modality,
            description: hd_modality_description,
            patient: patient,
            started_on: modality_started_on
          )
        end

        context "when an HD patient (a patient with the HD modality) has no HD profile" do
          it { is_expected.to be_nil }
        end

        context "when an HD patient has an HD profile created on the same day" do
          it "finds the profile" do
            profile = create(:hd_profile, patient: patient, created_at: modality.started_on)

            expect(resolved_profile_id).to eq(profile.id)
          end
        end

        context "when an HD patient has several HD profiles created on the same day" do
          it "resolved the last one created that day" do
            profiles = []
            travel_to modality_started_on do
              profiles << create(:hd_profile, patient: patient)
            end

            travel_to modality_started_on + 1.minute do
              profiles << ReviseHDProfile.new(profiles[0]).call(prescribed_time: 123, by: user)
            end

            travel_to modality_started_on + 2.minutes do
              profiles << ReviseHDProfile.new(profiles[1]).call(prescribed_time: 456, by: user)
            end

            expect(resolved_profile_id).to eq(profiles.last.id)
          end
        end

        context "when an HD patient an active HD Profile already" do
          it "resolved it" do
            hd_profile = travel_to modality_started_on - 1.year do
              create(:hd_profile, patient: patient)
            end

            expect(resolved_profile_id).to eq(hd_profile.id)
          end
        end

        context "when an HD modality has no HD profile in its lifespan" do
          it "looks ahead to find the first one it can and uses that" do
            old_hd_modality = create(
              :modality,
              description: hd_modality_description,
              patient: patient,
              started_on: 10.years.ago,
              ended_on: 9.years.ago
            )
            newer_hd_modality = create(
              :modality,
              description: hd_modality_description,
              patient: patient,
              started_on: 1.year.ago
            )
            hd_profile = travel_to newer_hd_modality.started_on + 1.day do
              create(:hd_profile, patient: patient)
            end

            expect(
              described_class.find_by!(modality_id: old_hd_modality.id).hd_profile_id
            ).to eq hd_profile.id

            expect(
              described_class.find_by!(modality_id: newer_hd_modality.id).hd_profile_id
            ).to eq hd_profile.id
          end
        end
      end
    end
  end
end
