module Renalware
  module HD
    describe DashboardPresenter do
      subject(:presenter) { described_class.new(patient, nil, user) }

      let(:patient) { create(:hd_patient) }
      let(:user) { create(:user, :clinical) }

      shared_examples "HD eligibility" do |allowed|
        it "uses modality eligibility for HD dashboard actions" do
          expect(presenter.has_ever_been_on_hd?).to eq(allowed)
          expect(presenter.can_add_session?).to eq(allowed)
          expect(presenter.can_add_dna_session?).to eq(allowed)
          expect(presenter.can_add_hd_profile?).to eq(allowed)
          expect(presenter.can_add_preference_set?).to eq(allowed)
        end
      end

      context "without any modalities" do
        it_behaves_like "HD eligibility", false
      end

      context "with a current modality that allows HD" do
        before do
          create(:modality, patient:,
                            description: create(:modality_description, allow_hd: true))
        end

        it_behaves_like "HD eligibility", true
      end

      context "with a historical modality that allows HD and no current modality" do
        before do
          create(:modality, :terminated, patient:, ended_on: Date.current,
                                         description: create(:modality_description, allow_hd: true))
        end

        it "has no current modality" do
          expect(patient.current_modality).to be_nil
        end

        it_behaves_like "HD eligibility", true
      end

      context "with an eligible historical modality and an ineligible current modality" do
        before do
          create(:modality, :terminated, patient:, ended_on: Date.current,
                                         description: create(:modality_description, allow_hd: true))
          create(:modality, patient:,
                            description: create(:modality_description, :pd, allow_hd: false))
        end

        it_behaves_like "HD eligibility", true
      end

      context "with current and historical HD modalities that do not allow HD" do
        before do
          description = create(:hd_modality_description, allow_hd: false)
          create(:modality, :terminated, patient:, description:, ended_on: Date.current)
          create(:modality, patient:, description:)
        end

        it_behaves_like "HD eligibility", false
      end

      context "when the user does not have write privileges" do
        let(:user) { create(:user, :read_only) }

        before do
          create(:modality, patient:,
                            description: create(:modality_description, allow_hd: true))
        end

        it "does not allow adding sessions, profiles or preferences" do
          expect(presenter).to have_ever_been_on_hd
          expect(presenter).not_to be_can_add_session
          expect(presenter).not_to be_can_add_dna_session
          expect(presenter).not_to be_can_add_hd_profile
          expect(presenter).not_to be_can_add_preference_set
        end
      end
    end
  end
end
