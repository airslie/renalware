module Renalware
  module Letters
    describe LetterPresenter do
      subject(:presenter) { described_class.new(letter) }

      let(:patient) { instance_double(Patient, local_patient_id: "A123", family_name: "Jones") }
      let(:letter) { instance_double(Letter, patient: patient, id: 111, state: :draft) }

      describe "#pdf_filename" do
        it "returns a formatted filename inclusing the letter state" do
          expect(presenter.pdf_filename).to eq("JONES-A123-111-DRAFT.pdf")
        end
      end

      describe "#pdf_stateless_filename" do
        it "returns a formatted filename exluding the letter state" do
          expect(presenter.pdf_stateless_filename).to eq("JONES-A123-111.pdf")
        end
      end

      describe "#parts" do
        let(:letter) {
          Letter.new \
            patient: Patient.new,
            topic: topic,
            letterhead: Letterhead.new,
            clinical: clinical
        }
        let(:topic) { nil }
        let(:clinical) { false }
        let(:sections) { [] }

        context "with clinical letter event" do
          let(:clinical) { true }

          it "returns clinical event sections" do
            expect(presenter.sections.size).to eq 4
            expect(presenter.sections[0]).to be_a Part::Problems
            expect(presenter.sections[1]).to be_a Part::Prescriptions
            expect(presenter.sections[2]).to be_a Part::RecentPathologyResults
            expect(presenter.sections[3]).to be_a Part::Allergies
          end
        end

        context "with an non-clinical letter event" do
          context "when topic is not present" do
            it "returns no sections" do
              expect(presenter.sections.size).to eq 0
            end
          end

          context "when topic is present" do
            let(:topic) { Topic.new(section_identifiers: sections) }

            context "when sections are present" do
              let(:sections) { [:hd_section] }

              it "returns a list of sections sorted by position" do
                expect(presenter.sections.size).to eq 1
                expect(presenter.sections[0]).to be_a HD::LetterExtensions::HDSection
              end
            end

            context "when sections are not present" do
              it "returns no sections" do
                expect(presenter.sections.size).to eq 0
              end
            end
          end
        end
      end
    end
  end
end
