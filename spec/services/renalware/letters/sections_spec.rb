RSpec.describe Renalware::Letters::Sections do
  let(:patient) { create(:patient) }
  let(:hd_patient) { patient.becomes(Renalware::HD::Patient) }
  let(:accesses_patient) { hd_patient.becomes(Renalware::Accesses::Patient) }
  let(:clinical_patient) { hd_patient.becomes(Renalware::Clinical::Patient) }
  let(:clinics_patient) { hd_patient.becomes(Renalware::Clinics::Patient) }
  let(:transplant_patient) { hd_patient.becomes(Renalware::Transplants::Patient) }
  let(:pathology_patient) { hd_patient.becomes(Renalware::Pathology::Patient) }

  let(:hd_profile) do
    create(
      :hd_profile,
      patient: hd_patient,
      schedule_definition:,
      prescribed_time: 210,
      by: create(:user)
    )
  end
  let(:rolling_patient_statistics) do
    create(:hd_patient_statistics, rolling: true, patient: hd_patient)
  end

  let(:schedule_definition) { create(:schedule_definition) }
  let(:hospital_unit) { hd_profile.hospital_unit }
  let(:dry_weight) do
    create(:dry_weight, patient: clinical_patient, minimum_weight: 128.2, maximum_weight: 162.3)
  end
  let(:access_plan) { create(:access_plan, patient: accesses_patient) }
  let(:access_profile) { create(:access_profile, patient: accesses_patient) }

  before do
    create(:clinic_visit, patient: clinics_patient)
    access_plan
    access_profile
    dry_weight
    hd_profile
    rolling_patient_statistics
  end

  describe "hd section" do
    let(:rows) { described_class.new(patient, "hd").all }

    context "when no values" do
      let(:hd_profile) { create(:hd_profile, patient: hd_patient) }
      let(:access_plan) { nil }
      let(:access_profile) { nil }
      let(:rolling_patient_statistics) { nil }
      let(:dry_weight) { nil }

      it "returns the correct number of rows" do
        expect(rows.count).to eq 2
      end

      it "does not include the entry" do
        expect(rows.first).to eq [
          { label: "HD Unit", value: "UJZ" }
        ]

        expect(rows.second).to eq [
          { label: "BMI", value: "0.7" }
        ]
      end
    end

    it "returns the correct number of rows" do
      expect(rows.count).to eq 4
    end

    it "returns the schedule information" do
      expect(rows.first).to eq [
        { label: "HD Unit", value: "UJZ" },
        { label: "Schedule", value: "Mon Wed Fri AM" },
        { label: "Time", value: "3:30" }
      ]
    end

    it "returns the access information" do
      expect(rows.second).to eq [
        { label: "HD Access", value: "Tunnelled subclav right" },
        { label: "Plan", value: "Continue #{I18n.l(Date.current)}" }
      ]
    end

    it "returns the observation details" do
      expect(rows.third).to eq [
        { label: "Mean pre HD BP", value: "120 / 80" },
        { label: "Mean post HD BP", value: "121 / 82" }
      ]
    end

    it "returns the dry weight details" do
      expect(rows.fourth).to eq [
        { label: "Dry Weight", value: "156.1" },
        { label: "Min Dry Weight", value: "128.2" },
        { label: "Max Dry Weight", value: "162.3" },
        { label: "BMI", value: "0.7" }
      ]
    end

    context "when post mean diastolic blood pressure is missing" do
      let(:rolling_patient_statistics) do
        create(
          :hd_patient_statistics,
          rolling: true,
          patient: hd_patient,
          post_mean_diastolic_blood_pressure: nil
        )
      end

      it "returns the correct number of rows" do
        expect(rows.count).to eq 4
      end

      it "does not include the joined values" do
        expect(rows.third).to eq [
          { label: "Mean pre HD BP", value: "120 / 80" }
        ]
      end
    end
  end

  describe "transplants section" do
    let(:rows) { described_class.new(patient, "transplants").all }

    let(:last_operation) do
      create(:transplant_recipient_operation, :with_document, patient: transplant_patient)
    end

    let(:current_observation_set) do
      create(:current_observation_set, patient: pathology_patient)
    end

    before do
      create(:pathology_code_group, :immunosuppressive)

      current_observation_set
      last_operation
    end

    it "returns the operation details" do
      expect(rows.first).to eq [
        { label: "Transplant Date", value: I18n.l(1.week.ago.to_date) },
        { label: "Organ Type", value: "Kidney only" },
        { label: "Donor Type", value: "Live related" }
      ]
    end

    it "returns the donor and recipient details" do
      expect(rows.second).to eq [
        { label: "Donor CMV", value: "Positive" },
        { label: "Recip CMV", value: "Negative" }
      ]
    end

    it "returns the pathology details" do
      expect(rows.third).to eq [
        { label: "Tacrolimus Level", value: "123" },
        { label: "Date", value: "12-Dec-2018" }
      ]
    end

    context "when no immunosuppressive data" do
      let(:current_observation_set) do
        create(:current_observation_set, patient: pathology_patient, values: {})
      end

      it "does not include immunosuppressive pathology row" do
        expect(rows.third).to be_nil
      end
    end
  end

  describe "pd section" do
    let(:rows) { described_class.new(patient, "pd").all }

    let(:pd_patient) { hd_patient.becomes(Renalware::PD::Patient) }
    let(:pd_regime) { create(:apd_regime, :with_tidal, patient: pd_patient) }
    let(:transplant_registration) do
      create(:transplant_registration, :with_ukt_status, patient: transplant_patient)
    end

    before do
      pd_regime
      transplant_registration
    end

    it "returns the regime details" do
      expect(rows[0]).to eq [
        { label: "Treatment", value: "APD Wet day with additional exchange" },
        { label: "Assistance", value: "Connect" },
        { label: "Exchanges Done By", value: "By patient" }
      ]
    end

    it "returns the weight details" do
      expect(rows[1]).to eq [
        { label: "Dry Weight", value: "156.1" },
        { label: "Min Dry Weight", value: "128.2" },
        { label: "Max Dry Weight", value: "162.3" },
        { label: "BMI", value: "0.7" }
      ]
    end

    context "when no weight range" do
      let(:dry_weight) { create(:dry_weight, patient: clinical_patient) }

      it "returns the weight & BMI only" do
        expect(rows[1]).to eq [
          { label: "Dry Weight", value: "156.1" },
          { label: "BMI", value: "0.7" }
        ]
      end
    end

    it "returns the UKT transplant status" do
      expect(rows[2]).to eq [
        { label: "UKT Transplant Status", value: "Positive" },
        { label: "Date", value: I18n.l(Date.current) }
      ]
    end

    context "when capd regime" do
      let(:pd_regime) { create(:capd_regime, patient: pd_patient) }

      it "returns the correct number of rows" do
        expect(rows.count).to eq 3
      end

      it "returns the capd details" do
        expect(rows[0].pluck(:label)).to eq [
          "Treatment", "Assistance", "Exchanges Done By"
        ]
        expect(rows[1].pluck(:label)).to eq [
          "Dry Weight", "Min Dry Weight", "Max Dry Weight", "BMI"
        ]
        expect(rows[2].pluck(:label)).to eq [
          "UKT Transplant Status", "Date"
        ]
      end
    end

    context "when apd regime" do
      it "returns the correct number of rows" do
        expect(rows.count).to eq 6
      end

      it "returns volume details" do
        expect(rows[3]).to eq [
          { label: "Overnight Volume", value: "8700 ml" },
          { label: "Daily Volume", value: "8700 ml" },
          { label: "Therapy Time", value: "2:00" },
          { label: "Cycles", value: "7" }
        ]
      end

      it "returns the tidal details" do
        expect(rows[4]).to eq [
          { label: "Tidal", value: "Yes" },
          { label: "Percentage", value: "70%" }
        ]
      end

      it "returns the fill volume details" do
        expect(rows[5]).to eq [
          { label: "Fill Volume", value: "1500 ml" },
          { label: "Last Fill Volume", value: "630 ml" }
        ]
      end
    end
  end

  describe "akcc section" do
    let(:rows) { described_class.new(patient, "akcc").all }

    let(:akcc_patient) { hd_patient.becomes(Renalware::LowClearance::Patient) }
    let(:transplant_registration) do
      create(:transplant_registration, :with_ukt_status, patient: transplant_patient)
    end

    before do
      create(
        :low_clearance_profile,
        :with_document,
        patient: akcc_patient,
        dialysis_plan: create(:low_clearance_dialysis_plan, :capd_la)
      )
      transplant_registration
    end

    it "returns the correct number of rows" do
      expect(rows.count).to eq 2
    end

    it "returns the profile details" do
      expect(rows[0]).to eq [
        { label: "Dialysis Plan", value: "CAPD LA" },
        { label: "Date First Seen", value: I18n.l(Date.current) }
      ]
    end

    it "returns the UKT transplant status" do
      expect(rows[1]).to eq [
        { label: "UKT Transplant Status", value: "Positive" },
        { label: "Date", value: I18n.l(Date.current) }
      ]
    end
  end
end
