# frozen_string_literal: true

module Renalware
  describe Patients::SummaryPart do
    subject(:summary_part) { described_class.new(patient, user) }

    let(:patient) { build_stubbed(:patient) }
    let(:user) { build_stubbed(:patients_user) }

    it { is_expected.to respond_to(:to_partial_path) }

    describe "#bookmark_notes" do
      subject { summary_part.bookmark_notes }

      context "when the current user has not bookmarked the patient" do
        it { is_expected.to be_nil }
      end

      context "when the current user has bookmarked the patient" do
        before do
          bookmark = build_stubbed(
            :patients_bookmark,
            user: user,
            patient: patient,
            notes: "XYZ"
          )
          allow(user).to receive(:bookmark_for_patient).and_return(bookmark)
          # The SummaryPart uses cast_user to guarantee that the user is of type
          # Patients::User. However this changes the user object reference so the above spy would
          # no longer work. To get around this, below we also stub the #patients_user method on the
          # SummaryPart so it does not call cast_patient, but returns the correct user object
          # so the above spy works.
          allow(summary_part).to receive(:patients_user).and_return(user)
        end

        it { is_expected.to eq("XYZ") }
      end
    end

    describe "#worryboard_notes" do
      subject { summary_part.worryboard_notes }

      context "when the patient is not on the worryboard" do
        it { is_expected.to be_nil }
      end

      context "when the patient is on the worryboard" do
        before do
          worry = Renalware::Patients::Worry.new(
            patient: patient,
            by: user,
            notes: "Abc"
          )
          allow(patient).to receive(:worry).and_return(worry)
        end

        it { is_expected.to eq("Abc") }
      end
    end
  end
end
