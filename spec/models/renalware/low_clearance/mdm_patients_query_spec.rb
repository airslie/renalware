module Renalware
  module LowClearance
    describe MDMPatientsQuery, type: :query do
      include PatientsSpecHelper
      include PathologySpecHelper

      def create_observation(patient, description, result, at: Time.zone.now)
        create_observations(Renalware::Pathology.cast_patient(patient),
                            description,
                            observed_at: at,
                            result: result)
      end

      let(:user) { create(:user) }

      def create_lcc_patient
        create(:patient).tap do |patient|
          set_modality(patient: patient,
                       modality_description: create(:low_clearance_modality_description),
                       by: user)
        end
      end

      def create_lcc_patient_with_dialysis_plan(plan_enum)
        create_lcc_patient.becomes(LowClearance::Patient).tap do |patient|
          profile = create(:low_clearance_profile, patient: patient, by: user)
          profile.document.dialysis_plan = plan_enum
          profile.save_by!(user)
        end
      end

      context "when unfiltered" do
        it "returns only AKCC patients" do
          lcc_patient = create_lcc_patient
          create(:patient)

          # Sanity check!
          expect(lcc_patient.current_modality.description.type).to eq(
            "Renalware::LowClearance::ModalityDescription"
          )

          patients = described_class.new(named_filter: nil, params: {}).call

          expect(patients.map(&:id)).to eq [lcc_patient.id]
        end
      end

      describe "filters" do
        describe "#on_worryboard" do
          it "returns only patients on the worryboard" do
            create_lcc_patient
            lcc_patient_with_worry = create_lcc_patient
            Renalware::Patients::Worry.new(patient: lcc_patient_with_worry, by: user).save!

            patients = described_class.new(named_filter: :on_worryboard).call

            expect(patients.map(&:id)).to eq [lcc_patient_with_worry.id]
          end
        end

        describe "#tx_candidates" do
          it "returns patients with a non '*permanent' registration status" do
            create_lcc_patient
            lcc_patient_on_tx_wait_list = create_lcc_patient.tap do |patient|
              create(
                :transplant_registration,
                :in_status,
                status: "active",
                patient: Renalware::Transplants.cast_patient(patient)
              )
            end

            patients = described_class.new(named_filter: :tx_candidates).call

            expect(patients.map(&:id)).to eq [lcc_patient_on_tx_wait_list.id]
          end

          it "excludes patients with a tx status of *permanent" do
            # Create a patient and give them with '*permament' Transplant registration status
            create_lcc_patient.tap do |patient|
              create(
                :transplant_registration,
                :in_status,
                status: "unfit_permanent",
                patient: Renalware::Transplants.cast_patient(patient)
              )
            end

            patients = described_class.new(named_filter: :tx_candidates).call

            expect(patients.map(&:id)).to eq []
          end
        end

        describe "#urea" do
          it "returns patients with most recent URE observation > 30" do
            ure = create_descriptions(%w(URE))

            create_lcc_patient # aka patient with no URE observation

            create_lcc_patient.tap do |patient_w_urea_lt_30|
              create_observation(patient_w_urea_lt_30, ure, 29)
            end

            create_lcc_patient.tap do |urea_lt_30_but_was_gt_30|
              create_observation(urea_lt_30_but_was_gt_30, ure, 31, at: 1.month.ago)
              create_observation(urea_lt_30_but_was_gt_30, ure, 29, at: Time.zone.now)
            end

            # target
            patient_w_urea_gt_30 = create_lcc_patient
            create_observation(patient_w_urea_gt_30, ure, 31)

            patients = described_class.new(named_filter: :urea).call

            expect(patients.map(&:id)).to eq [patient_w_urea_gt_30.id]
          end
        end

        describe "#hgb_low" do
          it "returns patients with most recent HGB observation < 100" do
            hgb = create_descriptions(%w(HGB))

            create_lcc_patient # aka patient with no HGB observation

            create_lcc_patient.tap do |hgb_eq_100|
              create_observation(hgb_eq_100, hgb, 100)
            end

            create_lcc_patient.tap do |hgb_gt_100_was_lt_100|
              create_observation(hgb_gt_100_was_lt_100, hgb, 99.9, at: 1.month.ago)
              create_observation(hgb_gt_100_was_lt_100, hgb, 100.1, at: Time.zone.now)
            end

            # Target
            patient_w_hgb_lt_100 = create_lcc_patient
            create_observation(patient_w_hgb_lt_100, hgb, 99.9, at: 1.month.ago)

            # This is a test to make sure that patients with a textual result, which is effectively
            # NULL (which is < 100 in the postgres world as far as ordering is concerned) still
            # appears in the < 100 group
            patient_w_textual_hgb = create_lcc_patient
            create_observation(patient_w_textual_hgb, hgb, "CANCELLED", at: 1.month.ago)

            patients = described_class.new(named_filter: :hgb_low).call

            expect(patients.map(&:id)).to eq [patient_w_hgb_lt_100.id, patient_w_textual_hgb.id]
          end
        end

        describe "#hgb_high" do
          it "returns patients with most recent HGB observation > 130" do
            hgb = create_descriptions(%w(HGB))

            create_lcc_patient # aka patient with no HGB observation

            create_lcc_patient.tap do |hgb_eq_130|
              create_observation(hgb_eq_130, hgb, 130)
            end

            create_lcc_patient.tap do |hgb_lt_130_but_was_gt_130|
              create_observation(hgb_lt_130_but_was_gt_130, hgb, 400, at: 1.month.ago)
              create_observation(hgb_lt_130_but_was_gt_130, hgb, 129, at: Time.zone.now)
            end

            # target
            patient_w_hgb_gt_130 = create_lcc_patient
            create_observation(patient_w_hgb_gt_130, hgb, 130.1)

            patients = described_class.new(named_filter: :hgb_high).call

            expect(patients.map(&:id)).to eq [patient_w_hgb_gt_130.id]
          end
        end
      end

      describe "#supportive_care" do
        it "returns patients with any supportive care option in thie LCC profile dialysis plan" do
          # Note re enums:
          # not_for_dial_patient_choice: Supportive care - patient choice
          # not_for_dial_consensus: Supportive Care - consensus
          create_lcc_patient # no lcc profile
          create_lcc_patient_with_dialysis_plan(:capd_la) # wrong plan
          choice_patient = create_lcc_patient_with_dialysis_plan(:not_for_dial_patient_choice)
          consensus_patient = create_lcc_patient_with_dialysis_plan(:not_for_dial_consensus)

          patients = described_class.new(named_filter: :supportive_care).call

          expect(patients.map(&:id).sort).to eq [choice_patient.id, consensus_patient.id]
        end
      end
    end
  end
end
