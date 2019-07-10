# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    describe TreatmentTimeline::GenerateTimeline do
      include PatientsSpecHelper

      subject(:service) { described_class.new(patient) }

      let(:user) { create(:user) }
      let(:patient) { create(:patient) }
      let(:hd_mod_desc) { create(:hd_modality_description) }
      let(:hd_ukrdc_modality_code) { create(:ukrdc_modality_code, :hd) }
      let(:hdf_ukrdc_modality_code) { create(:ukrdc_modality_code, :hdf) }

      context "when the patient has no modality" do
        it "does not generate a timeline row" do
          expect(patient.modalities.count).to eq(0)

          service.call

          expect(UKRDC::Treatment.count).to eq(0)
        end
      end

      context "when the patient has one simple modality" do
        it "generates one Treatment with the relevant UKRDC modality code" do
          set_modality(patient: patient, modality_description: hd_mod_desc, by: user)
          hd_ukrdc_modality_code

          service.call

          expect(UKRDC::Treatment.count).to eq(1)
          expect(UKRDC::Treatment.first).to have_attributes(
            modality_code: hd_ukrdc_modality_code,
            clinician: user,
            patient: patient,
            started_on: patient.current_modality.started_on,
            ended_on: nil
          )
        end
      end

      context "when the patient has 2 simple HD modalities (no profiles invovled)" do
        before do
          hd_ukrdc_modality_code
          hdf_ukrdc_modality_code
        end

        it "generates 2 Treatments with the relevant UKRDC modality code" do
          options = { patient: patient, modality_description: hd_mod_desc, by: user }
          modality1 = set_modality(options.merge(started_on: 1.month.ago))
          modality2 = set_modality(options.merge(started_on: 1.day.ago))
          modality1.reload # gets the change to ended_on caused by adding a successor

          service.call

          treatments = UKRDC::Treatment.ordered
          expect(treatments.size).to eq(2)
          expect(treatments.first).to have_attributes(
            modality_code_id: hd_ukrdc_modality_code.id,
            clinician_id: user.id,
            patient_id: patient.id,
            started_on: modality1.started_on,
            ended_on: modality1.ended_on
          )

          expect(treatments.last).to have_attributes(
            modality_code_id: hd_ukrdc_modality_code.id,
            clinician_id: user.id,
            patient_id: patient.id,
            started_on: modality2.started_on,
            ended_on: modality2.ended_on
          )
        end
      end

      describe "HD" do
        before do
          hd_ukrdc_modality_code
          hdf_ukrdc_modality_code
        end

        context "when an existing HD patient has an HD profile within 2 wks of the modal start" do
          # Such that it is assigned to the modality and in itself it does not trigger new
          # Treatment
          let(:initial_profile) do
            create(
              :hd_profile,
              patient: Renalware::HD.cast_patient(patient),
              prescribed_on: 2.weeks.ago,
              created_at: 2.weeks.ago,
              by: user
            )
          end

          before do
            initial_profile
            set_modality(
              patient: patient,
              modality_description: hd_mod_desc,
              by: user,
              started_on: 4.weeks.ago
            )
          end

          it "in combination with the modality it only outputs one Treatment" do
            service.call

            expect(UKRDC::Treatment.count).to eq(1)
          end

          context "when another profile is created with a changed hd_type" do
            it "triggers a new Treatment" do
              svc = HD::ReviseHDProfile.new(initial_profile)
              new_profile = svc.call(prescribed_time: 456, by: user)
              new_profile.document.dialysis.hd_type = :hdf_pre
              new_profile.save!

              service.call

              expect(UKRDC::Treatment.count).to eq(2)
            end
          end

          context "when another profile is created with a changed hospital_unit_id" do
            it "triggers a new Treatment" do
              other_unit = create(:hospital_unit, name: "X")
              svc = HD::ReviseHDProfile.new(initial_profile)
              svc.call(hospital_unit: other_unit, by: user)

              service.call

              expect(UKRDC::Treatment.count).to eq(2)
            end
          end

          context "when another profile is created a non-triggering change " do
            it "triggers a new Treatment" do
              other_unit = create(:hospital_unit, name: "X")
              svc = HD::ReviseHDProfile.new(initial_profile)
              svc.call(hospital_unit: other_unit, by: user)

              service.call

              expect(UKRDC::Treatment.count).to eq(2)
            end
          end
        end
      end
    end
  end
end
