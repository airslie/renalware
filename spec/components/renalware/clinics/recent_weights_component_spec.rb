# frozen_string_literal: true

module Renalware
  describe Clinics::RecentWeightsComponent, type: :component do
    let(:patient) { Clinics::Patient.new }
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
      let(:instance) { described_class.new(patient: patient) }

      context "with full data" do
        let(:dietetic_clinic) {
          Dietetics::ClinicVisit.new(
            date: Date.parse("2022-10-11"),
            weight: 72
          )
        }

        before do
          allow(patient.clinic_visits).to receive(:recent).and_return([dietetic_clinic])
        end

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
