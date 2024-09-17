# frozen_string_literal: true

module Renalware
  describe Dietetics::RecentHandgripsComponent, type: :component do
    let(:patient) { Patient.new }
    let(:instance) { described_class.new(patient: patient) }

    context "with no clinic visits" do
      it "renders empty table" do
        render_inline(instance)

        expect(instance.render?).to be(true)
        expect(page).to have_content("Recent Handgrips")
        expect(page).to have_content("DateLeftRight")
      end
    end

    context "with a last dietetic clinic visit" do
      let(:instance) {
        described_class.new(patient: patient, dietetic_clinic_visits_loader: proc {
                                                                               [dietetic_clinic]
                                                                             })
      }

      context "with full data" do
        let(:dietetic_clinic) {
          Dietetics::ClinicVisit.new(
            date: Date.parse("2022-10-11"),
            document: {
              handgrip_left: 10,
              handgrip_right: 10
            }
          )
        }

        it "renders a table" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Recent Handgrips")
          expect(page).to have_content("DateLeftRight")
          expect(page).to have_content("11-Oct-202210 kg10 kg")
        end
      end

      context "with no data" do
        let(:dietetic_clinic) { Dietetics::ClinicVisit.new }

        it "renders mostly empty" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Recent Handgrips")
          expect(page).to have_content("DateLeftRight")
        end
      end
    end
  end
end
