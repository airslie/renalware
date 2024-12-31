module Renalware
  describe PD::PeritonitisEpisode do
    include DrugsSpecHelper

    it :aggregate_failures do
      is_expected.to validate_presence_of :patient
      is_expected.to validate_presence_of :diagnosis_date
      is_expected.to have_many(:episode_types)
      is_expected.to belong_to(:patient).touch(true)
    end

    describe "peritonitis episode" do
      let(:patient) { create(:patient) }
      let(:episode) { create(:peritonitis_episode) }
      let(:mrsa) { create(:organism_code, name: "MRSA") }
      let(:ecoli) { create(:organism_code, name: "E.Coli") }
      let(:user) { create(:user) }

      describe "prescriptions" do
        it "can be assigned many prescriptions and organisms/sensitivities" do
          load_drugs_by_type(
            "Amoxicillin" => %w(Antibiotic Peritonitis),
            "Penicillin" => %w(Antibiotic Peritonitis)
          )

          load_med_routes

          prescription_one = create(
            :prescription,
            patient: patient,
            drug: @amoxicillin,
            treatable: episode,
            medication_route: @po,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 0,
            by: user
          )

          prescription_two = create(
            :prescription,
            patient: patient,
            drug: @penicillin,
            treatable: episode,
            medication_route: @iv,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: user
          )

          episode.prescriptions << prescription_one
          episode.prescriptions << prescription_two

          mrsa_sensitivity = episode.infection_organisms
            .build(organism_code: mrsa,
                   sensitivity: "Sensitive to MRSA.")
          @ecoli_sensitivity = episode.infection_organisms
            .build(organism_code: ecoli,
                   sensitivity: "Sensitive to E.Coli.")

          episode.save!
          episode.reload

          expect(episode.prescriptions.size).to eq(2)
          expect(episode.infection_organisms.size).to eq(2)

          expect(episode.prescriptions).to contain_exactly(prescription_two, prescription_one)
          expect(episode.infection_organisms).to contain_exactly(@ecoli_sensitivity,
                                                                 mrsa_sensitivity)

          expect(episode).to be_valid
        end
      end
    end
  end
end
