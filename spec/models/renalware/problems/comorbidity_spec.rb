module Renalware::Problems
  describe Comorbidity do
    let(:user) { create(:user) }

    it_behaves_like "an Accountable model"

    def create_comorbidity(patient:, recognised_at:, name: "X", position: 1, recognised: "yes")
      description = Comorbidities::Description.find_or_create_by!(name: name, position: position)
      described_class.create!(
        description: description,
        patient: patient,
        by: user,
        recognised_at: recognised_at,
        recognised: recognised
      )
    end

    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to belong_to(:patient)
      is_expected.to belong_to(:malignancy_site)
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:description)
      is_expected.to belong_to(:description)
      is_expected.to have_db_index(%i(patient_id description_id)).unique
      is_expected.to have_db_index(:patient_id)
      is_expected.to have_db_index(:description_id)
    end

    describe "uniqueness" do
      subject do
        described_class.create!(
          description: Comorbidities::Description.create!(name: "x"),
          patient: patient,
          by: user
        )
      end

      let(:user) { create(:user) }
      let(:patient) { create(:patient, by: user) }

      it { is_expected.to validate_uniqueness_of(:description).scoped_to(:patient_id) }
    end

    describe "#at_date" do
      let(:patient) { create(:patient) }

      context "when no date supplied" do
        context "when there are no comorbidities" do
          it "returns an empty array" do
            expect(patient.comorbidities.at_date(nil)).to eq([])
          end
        end

        context "when there are comorbidities" do
          it "returns an empty array" do
            create_comorbidity(patient: patient, recognised_at: "2010-01-01")

            expect(patient.comorbidities.at_date(nil)).to eq([])
          end
        end
      end

      context "when a date is supplied but there are no comorbidities" do
        it "returns an empty array" do
          expect(patient.comorbidities.at_date(Date.parse("2010-01-01"))).to eq([])
        end
      end

      context "when the supplied date is before any comorbidities" do
        it "returns an empty array" do
          create_comorbidity(patient: patient, recognised_at: "2020-01-01")

          expect(patient.comorbidities.at_date(Date.parse("2010-01-01"))).to eq([])
        end
      end

      context "when the supplied date is after any comorbidities" do
        it "returns the comorb" do
          como = create_comorbidity(patient: patient, recognised_at: "2010-01-01")

          expect(
            patient.comorbidities.at_date(Date.parse("2020-01-01"))
          ).to eq([como])
        end
      end
    end
  end
end
