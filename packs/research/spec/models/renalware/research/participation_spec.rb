# frozen_string_literal: true

module Renalware
  describe Research::Participation do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to be_versioned }
    it { is_expected.to validate_presence_of :patient_id }
    it { is_expected.to belong_to :patient }
    it { is_expected.to belong_to :study }
    it { is_expected.to have_db_index([:study_id, :external_reference]).unique(true) }

    describe "uniqueness" do
      subject {
        described_class.new(
          patient_id: patient.id,
          study: study,
          joined_on: "2018-01-01"
        )
      }

      let(:study) { create(:research_study) }
      let(:patient) { create(:patient) }

      it { is_expected.to validate_uniqueness_of(:external_id) }
      it { is_expected.to validate_uniqueness_of(:external_reference).scoped_to(:study_id) }
      it { is_expected.to validate_uniqueness_of(:patient_id).scoped_to(:study_id) }
    end

    describe ".external_application_participation_url" do
      subject do
        build_stubbed(:research_participation, study: study, external_id: "123")
          .external_application_participation_url
      end

      context "when the study has no application_link" do
        let(:study) { build_stubbed(:research_study, application_url: nil) }

        it { is_expected.to be_nil }
      end

      context "when the study has an application_link" do
        let(:study) { build_stubbed(:research_study, application_url: "http://test/{external_id}") }

        it { is_expected.to eq("http://test/123") }
      end
    end
  end
end
