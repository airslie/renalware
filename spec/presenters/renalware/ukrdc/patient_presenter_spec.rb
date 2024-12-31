module Renalware
  describe UKRDC::PatientPresenter do
    def rr_smoker(status)
      patient = Patient.new(sent_to_ukrdc_at: 1.year.ago)
      patient.document.history.smoking = status
      UKRDC::PatientPresenter.new(patient).rr_smoking_history
    end

    describe "#rr_smoking_history which converts RW enums to RRSMOKING codes" do
      it :aggregate_failures do
        expect(rr_smoker(:yes)).to eq("YES")
        expect(rr_smoker(:no)).to eq("NO")
        expect(rr_smoker(:ex)).to eq("EX")
      end
    end

    describe "#language" do
      subject(:presenter) { described_class.new(patient).language }

      let(:patient) do
        build_stubbed(:patient, language: language, sent_to_ukrdc_at: 1.year.ago)
      end

      context "when the patient has the language Unknown which is not in ISO 639" do
        let(:language) { build_stubbed(:language, :unknown) }

        it { is_expected.not_to be_present }
      end

      context "when the patient has the language Afrikaans" do
        let(:language) { build_stubbed(:language, :afrikaans) }

        it { is_expected.to be_present }
      end

      context "when the patient has no language" do
        let(:language) { nil }

        it { is_expected.not_to be_present }
      end
    end

    describe "#modalties" do
      subject(:presenter) { described_class.new(patient) }

      let(:patient) { create(:patient) }
      let(:user) { create(:user) }

      it "returns patient modalities in ascending chronological order" do
        hd_modality_description = create(:modality_description, :hd)
        pd_modality_description = create(:modality_description, :pd)
        tx_modality_description = create(:modality_description, :transplant)
        create(:modality_change_type, :default)

        # Create 3 modalities in this chronological order: PD, HD, Transplant
        # but insert them non-chronologically
        svc = Modalities::ChangePatientModality.new(patient: patient, user: user)

        # 1 Create an HD modality starting 2 weeks ago, ending 1 week ago
        expect(
          svc.call(
            description: pd_modality_description,
            started_on: 2.weeks.ago,
            ended_on: 1.week.ago,
            updated_at: 2.weeks.ago
          ).success?
        ).to be(true)

        # 2 Create an HD modality
        expect(
          svc.call(
            description: hd_modality_description,
            started_on: 2.days.ago,
            ended_on: 1.day.ago,
            updated_at: 25.hours.ago
          ).success?
        ).to be(true)

        # 3 Create a Tx modality which is the current one
        expect(
          svc.call(
            description: tx_modality_description,
            started_on: 1.day.ago,
            ended_on: nil,
            updated_at: 1.day.ago
          ).success?
        ).to be(true)

        patient.reload

        expected = %w(pd hd transplant)
        expect(presenter.modalities.map { |mod| mod.description.code }).to eq(expected)
      end
    end

    describe "#letters" do
      # Setup is a bit complicated because when the presenter casts the patient to a
      # Letters::Patient the object id changes, so we have to stub cast_patient to return a
      # known Letters::Patient instance. Then we put a spy on letters_patient.letters to
      # ensure it is or isn't called.
      def stub_letters_patient(patient)
        Letters.cast_patient(patient).tap do |letters_patient|
          allow(Letters).to receive(:cast_patient).and_return(letters_patient)
          allow(letters_patient).to receive(:letters).and_return(Letters::Letter.none)
        end
      end

      context "when the patient has opted-in to PKB (previously RPV)" do
        it "returns the patient's letters" do
          patient = build_stubbed(:patient, send_to_rpv: true, send_to_renalreg: true)
          letters_patient = stub_letters_patient(patient)

          described_class.new(patient).letters

          expect(letters_patient).to have_received(:letters)
        end
      end

      context "when the patient has not opted-in to PKB (previously RPV)" do
        it "returns an empty array even if the patient has letters" do
          patient = build_stubbed(:patient, send_to_rpv: false, send_to_renalreg: true)
          letters_patient = stub_letters_patient(patient)

          described_class.new(patient).letters

          expect(letters_patient).not_to have_received(:letters)
        end
      end
    end

    describe "#transplant_operations" do
      subject(:presenter) { described_class.new(patient) }

      let(:patient) { create(:transplant_patient) }
      let(:user) { create(:user) }

      it "returns a patients Tx operations in date ascending order" do
        op1 = create(:transplant_recipient_operation, patient: patient, performed_on: 1.month.ago)
        op2 = create(:transplant_recipient_operation, patient: patient, performed_on: 1.year.ago)

        expect(presenter.transplant_operations).to eq([op2, op1])
      end
    end

    describe "#prescriptions_with_numeric_dose_amount" do
      subject(:presenter) { described_class.new(patient) }

      let(:patient) { create(:patient) }
      let(:user) { create(:user) }

      it "returns those with a numeric dose_amount" do
        pre1 = create(:prescription, patient: patient, dose_amount: "  2222.22  ")
        pre2 = create(:prescription, patient: patient, dose_amount: "2")
        create(:prescription, patient: patient, dose_amount: "10,000")
        create(:prescription, patient: patient, dose_amount: "1-2")
        create(:prescription, patient: patient, dose_amount: "10%")
        create(:prescription, patient: patient, dose_amount: "UNSPEC")

        expect(presenter.prescriptions_with_numeric_dose_amount).to contain_exactly(pre1, pre2)
      end
    end
  end
end
