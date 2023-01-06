# frozen_string_literal: true

require "rails_helper"

module Renalware
  require "renalware/dietetics/recent_weights_component"

  describe Dietetics::Queries::RecentWeightsQuery, type: :component do
    describe "#call" do
      let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

      context "with clinic visits for patient" do
        let!(:clinic_visit_second) {
          create(:clinic_visit, patient: patient, date: Date.parse("2022-10-12"))
        }
        let!(:clinic_visit_first) {
          create(:clinic_visit, patient: patient, date: Date.parse("2022-10-15"))
        }

        it "returns them" do
          expect(described_class.new.call(patient: patient)).to eq([clinic_visit_first,
                                                                    clinic_visit_second])
        end
      end
    end
  end

  describe Dietetics::RecentWeightsComponent, type: :component do
    let(:patient) { Patient.new }
    let(:instance) { described_class.new(patient: patient) }

    context "with no clinic visits" do
      it "renders empty table" do
        render_inline(instance)

        expect(instance.render?).to be(true)
        expect(page).to have_content("Recent Weights")
        expect(page).to have_content("DateWeight")
      end
    end

    context "with a last dietetic clinic visit" do
      let(:instance) {
        described_class.new(patient: patient, clinic_visits_loader: proc {
                                                                      [dietetic_clinic]
                                                                    })
      }

      context "with full data" do
        let(:dietetic_clinic) {
          Dietetics::ClinicVisit.new(
            date: Date.parse("2022-10-11"),
            weight: 72
          )
        }

        it "renders a table" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Recent Weights")
          expect(page).to have_content("DateWeight")
          expect(page).to have_content("11-Oct-202272.0 kg")
        end
      end

      context "with no data" do
        let(:dietetic_clinic) { Dietetics::ClinicVisit.new }

        it "renders mostly empty" do
          render_inline(instance)

          expect(instance.render?).to be(true)

          expect(page).to have_content("Recent Weights")
          expect(page).to have_content("DateWeight")
        end
      end
    end
  end
end
