# frozen_string_literal: true

module Renalware
  module UKRDC
    describe TreatmentTimeline::PD::Generator do
      include PatientsSpecHelper
      subject(:generator) { described_class.new(modality) }

      let(:user) { create(:user) }
      let(:pd_ukrdc_modality_code) { create(:ukrdc_modality_code, :pd) }
      let(:apd_ukrdc_modality_code) { create(:ukrdc_modality_code, :apd) }
      let(:apd_assisted_ukrdc_modality_code) { create(:ukrdc_modality_code, :apd_assisted) }
      let(:capd_assisted_ukrdc_modality_code) { create(:ukrdc_modality_code, :capd_assisted) }
      let(:capd_ukrdc_modality_code) { create(:ukrdc_modality_code, :capd) }
      let(:pd_mod_desc) { create(:pd_modality_description) }
      let(:patient) { create(:patient) }
      let(:modality) do
        set_modality(
          patient: patient,
          modality_description: pd_mod_desc,
          by: user
        )
      end

      def create_regime(start_date:, end_date: nil, type: :apd_regime)
        regime = build(type,
                       add_hd: false,
                       patient: patient,
                       start_date: start_date,
                       end_date: end_date)
        regime.bags << build(:pd_regime_bag, :everyday)
        regime.save!
        regime
      end

      before do
        # Always make sure the default UKRDC PD code is in the db
        pd_ukrdc_modality_code
      end

      context "when the patient has the PD modality" do
        let(:patient) { create(:pd_patient) }

        context "when they have no PD regime" do
          it "creates one Treatment with a generic UKRDC treatment code of PD" do
            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              patient_id: patient.id,
              pd_regime_id: nil,
              modality_code: pd_ukrdc_modality_code,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_id: modality.id
            )
          end
        end

        context "when they have a APD regime active at the point of modality creation" do
          it "creates uses the regime type when creating the Treatment" do
            apd_ukrdc_modality_code
            regime = create_regime(start_date: 5.years.ago, end_date: nil, type: :apd_regime)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              modality_code: apd_ukrdc_modality_code,
              pd_regime_id: regime.id
            )
          end
        end

        context "when they have a CAPD regime active at the point of modality creation" do
          it "creates uses the regime type creating the Treatment" do
            capd_ukrdc_modality_code
            create_regime(start_date: 5.years.ago, end_date: nil, type: :capd_regime)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              modality_code: capd_ukrdc_modality_code
            )
          end
        end

        context "when there is a APD regime created within 100 yrs of the modality start date" do
          it "finds this initial regime, regardless of how far in the future it is, and " \
             "uses its type etc when creating the Treatment" do
            apd_ukrdc_modality_code
            create_regime(start_date: Time.zone.now + 99.years, end_date: nil, type: :apd_regime)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              modality_code: apd_ukrdc_modality_code
            )
          end
        end

        context "with 2 regimes of the same type" do
          before { apd_ukrdc_modality_code }

          it "creates a treatment for each" do
            create_regime(start_date: Time.zone.today, end_date: Date.parse("2049-01-04"),
                          type: :apd_regime)
            create_regime(start_date: Date.parse("2049-01-04"), end_date: nil, type: :apd_regime)

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(2)

            treatments = UKRDC::Treatment.order(started_on: :asc)
            expect(treatments[0]).to have_attributes(
              modality_code: apd_ukrdc_modality_code,
              started_on: Time.zone.today,
              ended_on: Date.parse("2049-01-04")
            )
            expect(treatments[1]).to have_attributes(
              modality_code: apd_ukrdc_modality_code,
              started_on: Date.parse("2049-01-04"),
              ended_on: nil
            )
          end
        end

        context "when has 2 PD regimes (APD then CAPD) created after the modality start date" do
          it "uses the first for the initial Treatment and creates " \
             "a futher Treatment to register the change from APD to APD" do
            apd_ukrdc_modality_code
            capd_ukrdc_modality_code

            # The first regime - this will be associated with the modality when creating
            # the first treatment record - is the treatment record will use its PD type etc
            create_regime(
              start_date: Time.zone.now,
              end_date: nil,
              type: :apd_regime
            )

            capd_regime = create_regime(
              start_date: Time.zone.now + 1.month,
              end_date: nil,
              type: :capd_regime
            )

            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(2)

            treatments = UKRDC::Treatment.order(started_on: :asc)
            expect(treatments[0]).to have_attributes(
              modality_code: apd_ukrdc_modality_code,
              started_on: modality.started_on,
              ended_on: capd_regime.start_date
            )
            expect(treatments[1]).to have_attributes(
              modality_code: capd_ukrdc_modality_code,
              started_on: capd_regime.start_date,
              ended_on: nil
            )
          end
        end
      end

      context "when they have an APD assisted regime" do
        it "creates uses the regime type when creating the Treatment" do
          apd_assisted_ukrdc_modality_code
          create_regime(
            start_date: Time.zone.now + 13.days,
            end_date: nil,
            type: :apd_assisted_regime
          )

          expect {
            generator.call
          }.to change(UKRDC::Treatment, :count).by(1)

          expect(UKRDC::Treatment.first).to have_attributes(
            modality_code: apd_assisted_ukrdc_modality_code
          )
        end
      end

      context "when they have an CAPD assisted regime" do
        it "creates uses the regime type when creating the Treatment" do
          capd_assisted_ukrdc_modality_code
          create_regime(
            start_date: Time.zone.now + 13.days,
            end_date: nil,
            type: :capd_assisted_regime
          )

          expect {
            generator.call
          }.to change(UKRDC::Treatment, :count).by(1)

          expect(UKRDC::Treatment.first).to have_attributes(
            modality_code: capd_assisted_ukrdc_modality_code
          )
        end
      end
    end
  end
end
