module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::MedicationsAndMedicalDevicesComponent, type: :component do
      subject(:component) { described_class.new(letter) }

      let(:user) { create(:user) }
      let(:patient) { create(:letter_patient, by: user) }
      let(:default_drug) { create(:drug, name: "::drug name::") }
      let(:hd_drug) { create(:drug, name: "::hd drug name::") }
      let(:letter) { instance_double(Renalware::Letters::Letter, patient: patient) }

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

      it "displays current prescriptions" do
        current_prescription

        render_inline(component)

        expect(page).to have_content("Current Medications")
        expect(page).to have_content("::drug name::")
        expect(page).to have_content("20 mg Oral daily GP")
        expect(page).to have_no_content("Drugs to give on Haemodialysis")
        expect(page).to have_content("Recently Stopped Medications")
        expect(page).to have_content("None")
      end

      it "displays HD prescriptions" do
        current_prescription(administer_on_hd: true, drug: hd_drug)

        render_inline(component)

        expect(page).to have_content("Current Medications")
        expect(page).to have_content("None")
        expect(page).to have_content("Drugs to give on Haemodialysis")
        expect(page).to have_content("::hd drug name::")
        expect(page).to have_content("20 mg Oral daily GP")
        expect(page).to have_content("Recently Stopped Medications")
        expect(page).to have_content("None")
      end

      it "displays recently stopped prescriptions" do
        terminated_prescription(terminated_on: 2.days.ago)

        render_inline(component)

        pending "fix tests as seems to be using current datetime"

        expect(page).to have_content("Current Medications")
        expect(page).to have_content("No medications")
        expect(page).to have_no_content("Drugs to give on Haemodialysis")
        expect(page).to have_content("::drug name::")
        expect(page).to have_content("20 mg Per Oral daily GP 20-Mar-2024")
        expect(page).to have_content("Recently Stopped Medications")
      end
    end
  end
end
