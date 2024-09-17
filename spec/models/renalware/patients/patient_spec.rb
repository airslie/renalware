# frozen_string_literal: true

require_relative "../concerns/personable"

module Renalware
  describe Patient do
    include PatientsSpecHelper
    subject(:patient) { create(:patient, nhs_number: "9999999999") }

    let(:user) { create(:user) }

    before do
      allow(Renalware.config)
        .to receive(:patients_must_have_at_least_one_hosp_number)
        .and_return(true)
    end

    it do
      aggregate_failures do
        is_expected.to be_versioned
        is_expected.to have_db_index(:ukrdc_external_id)
        is_expected.to have_db_index(:ukrdc_anonymise)
        is_expected.to have_db_index(:local_patient_id).unique(true)
        is_expected.to have_db_index(:local_patient_id_2).unique(true)
        is_expected.to have_db_index(:local_patient_id_3).unique(true)
        is_expected.to have_db_index(:local_patient_id_4).unique(true)
        is_expected.to have_db_index(:local_patient_id_5).unique(true)
        is_expected.to have_db_index(:renal_registry_id).unique(true)
      end
    end

    it_behaves_like "Personable"
    it_behaves_like "an Accountable model"

    it { is_expected.to belong_to :preferred_death_location }
    it { is_expected.to belong_to :actual_death_location }

    describe "handing blank local_patient_id* attributes" do
      it "local_patient_id" do
        expect(
          create(:patient, local_patient_id: "", local_patient_id_2: "A123")
        ).to have_attributes(local_patient_id: nil)
      end

      it "ids 2 to 5" do
        expect(
          create(
            :patient,
            by: user,
            local_patient_id_2: "",
            local_patient_id_3: "",
            local_patient_id_4: "",
            local_patient_id_5: ""
          )
        ).to have_attributes(
          local_patient_id_2: nil,
          local_patient_id_3: nil,
          local_patient_id_4: nil,
          local_patient_id_5: nil
        )
      end

      it "does not accidentally clear ids that have a value (belt and braces)" do
        ids = {
          local_patient_id: "1",
          local_patient_id_2: "2",
          local_patient_id_3: "3",
          local_patient_id_4: "4",
          local_patient_id_5: "5"
        }
        patient = create(:patient, by: user, **ids)
        expect(patient).to have_attributes(ids)
      end
    end

    describe "uniqueness of patient identifiers" do
      subject(:patient) {
        build(
          :patient,
          nhs_number: "9999999999",
          by: user,
          local_patient_id: "1",
          local_patient_id_2: "2",
          local_patient_id_3: "3",
          local_patient_id_4: "4",
          local_patient_id_5: "5",
          renal_registry_id: "abC"
        )
      }

      it do
        aggregate_failures do
          is_expected.to validate_uniqueness_of(:nhs_number).case_insensitive
          is_expected.to validate_uniqueness_of(:local_patient_id).case_insensitive
          is_expected.to validate_uniqueness_of(:renal_registry_id)
        end
      end

      (2..5).each do |idx|
        it { is_expected.to validate_uniqueness_of(:"local_patient_id_#{idx}").case_insensitive }
      end
    end

    it :aggregate_failures do
      is_expected.to validate_length_of(:nhs_number).is_equal_to(10)
      is_expected.to validate_presence_of :family_name
      is_expected.to validate_presence_of :given_name
      is_expected.to validate_timeliness_of(:died_on)
      is_expected.to have_many(:alerts)
      is_expected.to belong_to(:country_of_birth)
      is_expected.to belong_to(:named_consultant)
      is_expected.to respond_to(:patient_at?)
    end

    describe "#born_on" do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:born_on)
        is_expected.to validate_timeliness_of(:born_on)
      end

      it "is invalid if before 01-Jan-1880" do
        patient = described_class.new(born_on: "1880-01-01").tap(&:valid?)
        expect(patient.errors[:born_on]).to include("must be after 01-Jan-1880")
      end

      it "is valid if after 01-Jan-1880" do
        patient = described_class.new(born_on: "1880-01-02").tap(&:valid?)
        expect(patient.errors[:born_on]).not_to include("must be after 01-Jan-1880")
      end
    end

    describe "#nhs_number_formatted" do
      it "inserts spaces as per the NHS spec if the number is 10 digits" do
        {
          nil => nil,
          "0000000000" => "000 000 0000",
          "9999999999" => "999 999 9999",
          "999999999" => "999999999", # (only 9 digits so will not format it)
          "" => "",
          "0123456789" => "012 345 6789",
          "  " => "  ",
          "111" => "111",
          "test" => "test",
          "012 345 6789" => "012 345 6789"
        }.each do |real, formatted|
          expect(described_class.new(nhs_number: real).nhs_number_formatted).to eq(formatted)
        end
      end
    end

    describe "diabetic? delegates to document.diabetes.diagnosis" do
      context "when the patient is diabetic" do
        before { allow(patient.document.diabetes).to receive(:diagnosis).and_return(true) }

        it { is_expected.to be_diabetic }
      end

      context "when the patient is not diabetic" do
        before { allow(patient.document.diabetes).to receive(:diagnosis).and_return(false) }

        it { is_expected.not_to be_diabetic }
      end
    end

    describe "#valid?" do
      context "when the current modality is death" do
        before { allow(patient).to receive(:current_modality_death?).and_return(true) }

        it "doesn't validate death attributes by default", :aggregate_failures do
          expect(patient).not_to validate_presence_of(:died_on)
          expect(patient).not_to validate_presence_of(:first_cause_id)
        end

        context "when #do_death_validations is true" do
          before { patient.do_death_validations = true }

          it :aggregate_failures do
            expect(patient).to validate_presence_of(:died_on)
            expect(patient).to validate_presence_of(:first_cause_id)
          end
        end
      end

      context "when the current modality is not death" do
        before { allow(patient).to receive(:current_modality_death?).and_return(false) }

        it :aggregate_failures do
          expect(patient).not_to validate_presence_of(:died_on)
          expect(patient).not_to validate_presence_of(:first_cause_id)
        end
      end

      it "validates sex" do
        patient.sex = "X"

        expect(patient).not_to be_valid
      end

      describe "patient identification validation" do
        before do
          allow(Renalware.config).to receive_messages(
            patient_hospital_identifiers: {
              HOSP1: :local_patient_id,
              HOSP2: :local_patient_id_2,
              HOSP3: :local_patient_id_3,
              HOSP4: :local_patient_id_4,
              HOSP5: :local_patient_id_5
            },
            patients_must_have_at_least_one_hosp_number: true
          )
        end

        let(:error_message) {
          "The patient must have at least one of these numbers: " \
            "HOSP1, HOSP2, HOSP3, HOSP4, HOSP5, Other Hospital Number"
        }
        let(:error_message2) {
          "The patient must have at least one of these numbers: NHS, HOSP1, HOSP2, HOSP3, " \
            "HOSP4, HOSP5, Other Hospital Number"
        }

        context "when the patient has no local_patient_id" do
          it "is invalid" do
            patient = described_class.new

            expect(patient).not_to be_valid
            expect(patient.errors[:base]).to include(error_message)
          end
        end

        context "when config does not enforce the 'at least one hosp num' validation" do
          before do
            allow(Renalware.config)
              .to receive(:patients_must_have_at_least_one_hosp_number)
              .and_return(false)
          end

          it "is invalid when no nhs_number supplied" do
            patient = described_class.new

            expect(patient).not_to be_valid

            expect(patient.errors[:base]).to include(error_message2)
          end

          it "is valid when an nhs_number is present" do
            patient = described_class.new
            patient.nhs_number = "9999999999"

            expect(patient).not_to be_valid

            expect(patient.errors[:base]).not_to include(error_message2)
          end
        end

        context "when the patient has just a local_patient_id" do
          it "is valid" do
            patient = described_class.new(local_patient_id: "A123")

            expect(patient.errors[:base] || []).not_to include(error_message)
          end
        end

        context "when the patient has just a local_patient_id_2" do
          it "is valid" do
            patient = described_class.new(local_patient_id_2: "A123")

            expect(patient.errors[:base] || []).not_to include(error_message)
          end
        end
      end
    end

    describe "#update" do
      context "when #died_on is specified" do
        it "stills retain patient details" do
          patient = create(:patient)
          expect {
            patient.update(died_on: "2015-02-25", by: user)
          }.not_to change(described_class, :count)
        end
      end
    end

    describe "#sex" do
      it "serializes gender" do
        expect(patient.sex).to be_a Gender
      end

      it "deserializes gender" do
        patient.sex = Gender.new("F")
        patient.by = user
        patient.save! && patient.reload

        expect(patient.sex.code).to eq "F"
      end
    end

    describe "local patient ids" do
      it "trims and upcases them when saved" do
        patient = build(:patient, local_patient_id: "  k123 ", local_patient_id_2: " x456")

        patient.save!

        expect(patient.reload).to have_attributes(
          local_patient_id: "K123",
          local_patient_id_2: "X456"
        )
      end
    end

    describe "#current_modality" do
      it "returns the most recent non-deleted modality" do
        create(:modality, patient: patient, started_on: "2015-04-19", ended_on: "2015-04-20")
        create(:modality, patient: patient, started_on: "2015-04-20", ended_on: "2015-04-20")
        create(:modality, :terminated, patient: patient, started_on: "2015-04-21")

        expect(patient.current_modality.started_on).to eq(Date.parse("2015-04-20"))
      end
    end

    describe "#previous_modality" do
      it "returns last modality after the current one" do
        user = create(:user)
        hd = create(:hd_modality_description)
        death = create(:death_modality_description)
        args = { patient: patient, by: user }
        set_modality(started_on: "2015-04-19", modality_description: hd, **args)
        set_modality(started_on: "2015-04-20", modality_description: hd, **args)
        prev = set_modality(started_on: "2015-04-21", modality_description: hd, **args)
        curr = set_modality(started_on: "2015-04-21", modality_description: death, **args)

        expect(patient.current_modality.started_on).to eq(curr.started_on)
        expect(patient.previous_modality.started_on).to eq(prev.started_on)
      end
    end

    describe "#secure_id_dashed" do
      subject { described_class.new(secure_id: uuid).secure_id_dashed }

      let(:uuid) { "41a63bce-f786-47bb-aba3-c6ee6aa1e90e" }

      it { is_expected.to eq(uuid) }
    end

    describe "#to_s" do
      subject { patient.to_s(format) }

      let(:patient) {
        described_class.new(title: title, family_name: "A", given_name: "B", nhs_number: nhs_number)
      }
      let(:format) { :default }
      let(:title) { "Mrs" }
      let(:nhs_number) { "1" }

      context "when the patient has a title" do
        let(:title) { "Mrs" }

        it { is_expected.to eq("A, B (Mrs)") }
      end

      context "when the patient has no title" do
        let(:title) { "" }

        it { is_expected.to eq("A, B") }
      end

      context "when the format is :long" do
        let(:format) { :long }

        context "when there is an nhs_number" do
          let(:nhs_number) { "1" }

          it { is_expected.to eq("A, B (Mrs) (1)") }
        end

        context "when there is no nhs_number" do
          let(:nhs_number) { "" }

          it { is_expected.to eq("A, B (Mrs)") }
        end

        context "when there is no nhs_number and no title" do
          let(:nhs_number) { "" }
          let(:title) { "" }

          it { is_expected.to eq("A, B") }
        end
      end
    end

    describe "#ukrdc_external_id" do
      context "when the patient is saved without a value being explicitly set" do
        it "postgres creates a default value" do
          patient = create(:patient)

          expect(patient.reload.ukrdc_external_id.length).to be > 0
        end
      end
    end

    describe "has_paper_trail declaration" do
      it "#create creates a new version" do
        with_versioning do
          expect {
            create(:patient)
          }.to change(Patients::Version, :count).by(1)
        end
      end

      it "#update creates a new version" do
        patient = create(:patient)
        with_versioning do
          expect {
            patient.update(family_name: "X", by: patient.created_by)
          }.to change(Patients::Version, :count).by(1)
        end
      end

      it "#touch does not create a new version" do
        patient = create(:patient)
        expect {
          patient.touch
        }.not_to change(Patients::Version, :count)
      end

      it "#destroy" do
        patient = create(:patient)
        with_versioning do
          expect {
            patient.destroy!
          }.to change(Patients::Version, :count).by(1)
        end
      end
    end
  end
end
