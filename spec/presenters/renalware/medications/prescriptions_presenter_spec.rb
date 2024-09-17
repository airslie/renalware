# frozen_string_literal: true

module Renalware
  module Medications
    describe PrescriptionsPresenter do
      subject(:presenter) { described_class.new(patient) }
      let(:user) { create(:user) }
      let(:patient) { create(:letter_patient, by: user) }
      let(:default_drug) { create(:drug, name: "::drug name::") }

      def terminated_prescription(terminated_on:, drug: default_drug)
        create(:prescription,
               patient: patient,
               drug: drug,
               prescribed_on: "2009-01-01",
               termination: build(:prescription_termination, terminated_on: terminated_on),
               by: user)
      end

      def current_prescription(
        prescribed_on: "2009-01-01",
        drug: default_drug,
        administer_on_hd: false
      )
        create(:prescription,
               patient: patient,
               drug: drug,
               prescribed_on: prescribed_on,
               updated_at: prescribed_on,
               created_at: prescribed_on,
               administer_on_hd: administer_on_hd,
               by: user)
      end

      # describe "#to_s" do
      #   it "returns a string as close as possible to NHS guidelines" do
      #     drug = instance_double(Renalware::Drugs::Drug, name: "Drug X", to_s: "Drug X")
      #     unit_of_measure = instance_double(Renalware::Drugs::UnitOfMeasure, name: "mg")
      #     prescription = instance_double(
      #       Prescription,
      #       drug: drug,
      #       dose_amount: "10",
      #       unit_of_measure: unit_of_measure,
      #       medication_route: instance_double(MedicationRoute, name: "PO", other?: false),
      #       frequency: "nocte",
      #       frequency_comment: "abc",
      #       drug_name: "Drug X"
      #     )
      #     presenter = described_class.new(prescription)

      #     expect(presenter.to_s).to eq("Drug X - DOSE 10 mg - PO - nocte abc")
      #   end
      # end

      def current_prescription(
        prescribed_on: "2009-01-01",
        drug: default_drug,
        administer_on_hd: false
      )
        create(:prescription,
               patient: patient,
               drug: drug,
               prescribed_on: prescribed_on,
               updated_at: prescribed_on,
               created_at: prescribed_on,
               administer_on_hd: administer_on_hd,
               by: user)
      end

      describe "self" do
        it "returns an OpenStruct of different sets of prescriptions" do
          expect(presenter).to respond_to(:current)
          expect(presenter).to respond_to(:current_hd)
          expect(presenter).to respond_to(:recently_changed)
          expect(presenter).to respond_to(:recently_stopped)
        end
      end

      describe "#current" do
        it "comprises only current prescriptions" do
          terminated_prescription(terminated_on: Time.zone.today - 1.day)
          current_prescription(administer_on_hd: true)
          current_non_hd = current_prescription(administer_on_hd: false)
          expect(presenter.current.to_a).to eq([current_non_hd])
        end
      end

      # describe "#recently_stopped" do
      #   it "comprises prescriptions stopped within the last 14 days having a drug which is not
      #      "in the #current list" do
      #     other_drug = create(:drug, name: "a drug not in the current list")

      #     expect(presenter.current.to_a).to eq([current_non_hd])
      #   end
      # end

      describe "#recently_changed" do
        it "comprises only prescriptions changed in the last 14 days" do
          terminated_prescription(terminated_on: 1.day.ago)
          current_prescription(prescribed_on: 15.days.ago)
          recently_changed = current_prescription(prescribed_on: 13.days.ago)
          recently_changed_hd =
            current_prescription(prescribed_on: 12.days.ago, administer_on_hd: true)

          expect(presenter.recently_changed.to_a.sort)
            .to eq([recently_changed, recently_changed_hd])
        end
      end

      describe "#recently_stopped" do
        it "comprises prescriptions stopped within the last 14 days having a drug which is not in" \
           "the #current list" do
          other_drug = create(:drug, name: "a drug not in the current list")

          # No as not terminated
          current_prescription
          # No we already have drug in current list
          terminated_prescription(terminated_on: 13.days.ago)
          # No as not within 14 days
          terminated_prescription(terminated_on: 15.days.ago)
          # YES as terminated and drug not in current list
          recently_stopped_prescription = terminated_prescription(terminated_on: 13.days.ago,
                                                                  drug: other_drug)

          expect(presenter.recently_stopped.to_a).to eq([recently_stopped_prescription])
        end
      end

      describe "#current_hd" do
        it "comprises current prescriptions to give on HD only" do
          patient.prescriptions << terminated_prescription(terminated_on: Time.zone.today - 1.day)
          current_prescription(administer_on_hd: false)
          current_hd_prescription = current_prescription(administer_on_hd: true)

          expect(presenter.current_hd.to_a).to eq([current_hd_prescription])
        end
      end
    end
  end
end
