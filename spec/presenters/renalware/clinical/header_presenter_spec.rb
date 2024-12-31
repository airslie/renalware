describe Renalware::Clinical::HeaderPresenter do
  include PathologySpecHelper
  subject(:presenter) { described_class.new(patient) }

  let(:clinic) { create(:clinic) }
  let(:patient) { create(:patient, by: user) }
  let(:user) { create(:user) }

  describe "current_pathology" do
    it "returns most recent results by delegating to the patient's current obs set" do
      value = "1.11"
      date = Time.zone.now.to_date
      descriptions = create_descriptions(%w(HGB PLT))
      create_observations(Renalware::Pathology.cast_patient(patient), descriptions, result: value)

      current_path = presenter.current_pathology
      expect(current_path.hgb_result).to eq(value)
      expect(current_path.hgb_observed_at).to eq(date)

      expect(current_path.plt_result).to eq(value)
      expect(current_path.plt_observed_at).to eq(date)
    end
  end

  describe "clinical observations" do
    describe "weight" do
      context "when there are clinic visits with weight measurements" do
        before do
          create_clinic_visit(Date.parse("2012-12-12"), weight: 103.1)
          create_clinic_visit(Date.parse("2010-12-12"), weight: 104.1)
        end

        it "has the most observation" do
          expect(presenter.weight_measurement).to eq(103.1)
          expect(presenter.weight_date).to eq(Date.parse("2012-12-12"))
        end
      end

      context "when there are no clinic visits with these measurements" do
        it "date and measurement are nil" do
          expect(presenter.weight_measurement).to be_nil
          expect(presenter.weight_date).to be_nil
        end
      end
    end

    describe "height" do
      context "when there are clinic visits with these measurements" do
        before do
          create_clinic_visit(Date.parse("2010-12-12"), height: 1.40)
          create_clinic_visit(Date.parse("2012-12-12"), height: 1.41)
        end

        it "has the most recent observation" do
          expect(presenter.height_measurement).to eq(1.41)
          expect(presenter.height_date).to eq(Date.parse("2012-12-12"))
        end
      end

      context "when there are no clinic visits with these measurements" do
        it "date and measurement are nil" do
          expect(presenter.height_measurement).to be_nil
          expect(presenter.height_date).to be_nil
        end
      end
    end

    describe "blood pressure" do
      context "when there are clinic visits with these measurements" do
        before do
          create_clinic_visit(Date.parse("2010-12-12"), systolic_bp: 112, diastolic_bp: 71)
          create_clinic_visit(Date.parse("2012-12-12"), systolic_bp: 110, diastolic_bp: 70)
        end

        it "has the most recent observation" do
          expect(presenter.blood_pressure_measurement).to eq([110, 70])
          expect(presenter.blood_pressure_date).to eq(Date.parse("2012-12-12"))
        end
      end

      context "when there are no clinic visits with these measurements" do
        it "date and measurement are nil" do
          expect(presenter.height_measurement).to be_nil
          expect(presenter.height_date).to be_nil
        end
      end
    end

    describe ".bmi" do
      subject { presenter.bmi.measurement }

      before do
        create_clinic_visit(Date.parse("2010-12-12"), height: 1.8)
        create_clinic_visit(Date.parse("2012-12-12"), weight: 80)
      end

      it { is_expected.to eq(35.6) }
    end

    def create_clinic_visit(date, **)
      create(:clinic_visit, patient_id: patient.id, date: date, clinic: clinic, by: user, **)
    end
  end
end
