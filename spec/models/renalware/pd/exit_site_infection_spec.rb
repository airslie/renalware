module Renalware
  describe PD::ExitSiteInfection do
    include DrugsSpecHelper

    it :aggregate_failures do
      is_expected.to validate_presence_of :patient
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to validate_presence_of :diagnosis_date
    end

    describe "exit site infection" do
      let(:patient) { create(:patient) }
      let(:esi) { create(:exit_site_infection) }
      let(:lymphocytes) { create(:organism_code, name: "Lymphocytes") }
      let(:proteus) { create(:organism_code, name: "Proteus") }
      let(:user) { create(:user) }

      describe "prescriptions" do
        it "can be assigned many prescriptions and organisms/sensitivities" do
          load_drugs_by_type(
            "Cephradine" => %w(Antibiotic Peritonitis),
            "Dicloxacillin" => %w(Antibiotic Peritonitis)
          )

          load_med_routes

          prescription_one = create(
            :prescription,
            patient: patient,
            drug: @cephradine,
            treatable: esi,
            medication_route: @im,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: user
          )

          prescription_two = create(
            :prescription,
            patient: patient,
            drug: @dicloxacillin,
            treatable: esi,
            medication_route: @sc,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: user
          )

          @lymphocytes_sensitivity = esi.infection_organisms
            .build(organism_code: lymphocytes,
                   sensitivity: "Sensitive to Lymphocytes.")
          @proteus_sensitivity = esi.infection_organisms
            .build(organism_code: proteus,
                   sensitivity: "Sensitive to Proteus.")

          esi.prescriptions << prescription_one
          esi.prescriptions << prescription_two

          esi.save!
          esi.reload

          expect(esi.prescriptions.size).to eq(2)
          expect(esi.infection_organisms.size).to eq(2)
          expect(esi.prescriptions).to contain_exactly(prescription_two, prescription_one)
          expect(esi.infection_organisms).to contain_exactly(@proteus_sensitivity,
                                                             @lymphocytes_sensitivity)
          expect(esi).to be_valid
        end
      end
    end
  end
end
