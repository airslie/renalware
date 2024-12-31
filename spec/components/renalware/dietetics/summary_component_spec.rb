module Renalware
  describe Dietetics::SummaryComponent, type: :component do
    let(:patient) { Patient.new }
    let(:instance) { described_class.new(patient: patient) }

    context "with no dietetic clinic visit" do
      it "renders nothing" do
        render_inline(instance)

        expect(instance.render?).to be(true)
        expect(page).to have_content("No dietetic visits")
      end
    end

    context "with a last dietetic clinic visit" do
      let(:instance) {
        described_class.new(patient: patient, last_dietetic_visit_loader: proc {
                                                                            dietetic_clinic
                                                                          })
      }

      context "with full data" do
        let(:dietetic_clinic) {
          Dietetics::ClinicVisit.new(
            date: Date.parse("2022-10-11"),
            document: {
              energy_requirement: 120,
              energy_intake: 40,
              sga_assessment: "well_nourished",
              ideal_body_weight: 72,
              dietary_protein_intake: 199,
              dietary_protein_requirement: 87
            }
          )
        }

        it "renders summary information" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Dietetic Profile")
          expect(page).to have_content("Date11-Oct-2022")
          expect(page).to have_content("Ideal body weight72")
          expect(page).to have_content("SgaA - Well nourished")
          expect(page).to have_content("Estimated energy intake40 kcal/day")
          expect(page).to have_content("Estimated energy requirement120 kcal/day")
          expect(page).to have_content("Estimated protein intake199 g/day")
          expect(page).to have_content("Estimated protein requirement87 g/day")
        end
      end

      context "with no data" do
        let(:dietetic_clinic) { Dietetics::ClinicVisit.new }

        it "renders mostly empty" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Dietetic Profile")
          expect(page).to have_content("Date")
          expect(page).to have_content("Ideal body weight")
          expect(page).to have_content("Estimated energy intake")
          expect(page).to have_content("Estimated energy requirement")
          expect(page).to have_content("Sga")
          expect(page).to have_content("Estimated energy intake")
          expect(page).to have_content("Estimated energy requirement")
          expect(page).to have_content("Estimated protein intake")
          expect(page).to have_content("Estimated protein requirement")
        end
      end
    end
  end
end
