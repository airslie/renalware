# frozen_string_literal: true

module Renalware::Letters
  describe Letter::PendingReview do
    include LettersSpecHelper

    subject(:letter) { raw_letter.becomes(described_class) }

    let(:user) { build(:user) }
    let(:primary_care_physician) { build(:letter_primary_care_physician) }
    let(:practice) do
      build(:practice).tap { |prac| prac.build_address(attributes_for(:address)) }
    end
    let(:patient) do
      build(
        :letter_patient,
        primary_care_physician: primary_care_physician,
        practice: practice
      )
    end
    let(:raw_letter) { build_letter(to: :patient, patient: patient) }

    describe "#sign" do
      it "creates a signature" do
        now = Time.zone.parse("2004-11-24 01:04:44")
        travel_to now

        signature = letter.sign(by: user).signature

        expect(signature).to be_valid
        expect(signature.user).to eq(user)
        expect(signature.signed_at).to eq(now)
      end
    end

    describe "#generate_archive" do
      let(:presenter) { double(:presenter, content: "hello world", pdf_content: "pdf") }

      it "archives the letter" do
        archived_letter = letter.generate_archive(by: user, presenter: presenter)
        expect(archived_letter).to be_archived
      end

      context "when the letter is persisted" do
        # Primary Care Physician has to exist before saving a letter
        let(:primary_care_physician) { create(:letter_primary_care_physician) }

        before do
          raw_letter.save
        end

        it "records who archived the letter" do
          user = create(:user)
          archived_letter = letter.generate_archive(by: user)
          archived_letter.save
          expect(archived_letter.archived_by).to eq(user)
        end

        it "archives the content" do
          content = letter.generate_archive(by: user).archive.content
          expect(content).to match(/class="unit-info"/)
          expect(content).to include(patient.full_name)
          expect(content).to include(patient.practice.address.street_1)
        end

        it "includes the GP CC name and address at the end of the letter (does not appear " \
           "in the print version but we keep in the archive copy for reference" do
          content = letter.generate_archive(by: user).archive.content
          expect(content).to include(patient.primary_care_physician.to_s)
        end
      end
    end
  end
end
