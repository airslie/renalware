# frozen_string_literal: true

require "rails-controller-testing"

module Renalware
  describe PD::RegimesController, type: :controller do
    routes { Engine.routes }
    let(:user) { @current_user }
    let(:patient) { create(:patient, by: user) }
    let(:bag_type) { create(:bag_type) }

    def create_capd_regime
      create(
        :capd_regime,
        bags_attributes: [
          bag_type: bag_type,
          role: :additional_manual_exchange,
          volume: 600,
          sunday: true,
          monday: true,
          tuesday: true,
          wednesday: true,
          thursday: true,
          friday: true,
          saturday: true
        ]
      )
    end
    describe "GET #new" do
      it "renders the new template" do
        get :new, params: { patient_id: patient }
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "creates a new CAPD Regime" do
          system = create(:capd_system)
          expect do
            post :create,
                 params: {
                   patient_id: patient,
                   pd_regime: {
                     type: "Renalware::PD::CAPDRegime",
                     start_date: "01/02/2015",
                     treatment: "CAPD 3 exchanges per day",
                     system_id: system.id,
                     delivery_interval: "P4W",
                     bags_attributes: [
                       bag_type_id: bag_type.id,
                       role: :additional_manual_exchange,
                       volume: 600,
                       sunday: true,
                       monday: true,
                       tuesday: true,
                       wednesday: true,
                       thursday: true,
                       friday: true,
                       saturday: true
                     ]
                   }
                 }
          end.to change(PD::Regime, :count).by(1)

          expect(response).to redirect_to(patient_pd_dashboard_path(patient))

          regime = patient.pd_regimes.first
          expect(regime.system).to eq(system)
          expect(regime.delivery_interval).to eq("P4W")
          expect(regime.bags.count).to eq(1)

          bag = regime.bags.first
          expect(bag.role.additional_manual_exchange?).to be(true)
        end
      end

      context "with invalid attributes" do
        it "does not create a new CAPD Regime" do
          system = create(:apd_system)
          expect {
            post :create,
                 params: {
                   patient_id: patient,
                   system_id: system.id,
                   delivery_interval: "P4W",
                   pd_regime: {
                     type: "Renalware::PD::CAPDRegime",
                     start_date: nil,
                     treatment: nil
                   }
                 }
          }.not_to change(PD::Regime, :count)

          expect(response).to render_template(:new)
        end
      end

      describe "adding a bag" do
        it "adds a bag to the unsaved CAPD Regime" do
          create_capd_regime
          expect(PD::RegimeBag.count).to eq(1)
          expect {
            post :create,
                 params: {
                   patient_id: patient,
                   actions: { add_bag: "Add Bag" },
                   pd_regime: {
                     type: "Renalware::PD::CAPDRegime",
                     start_date: Time.zone.today,
                     treatment: "CAPD 3 exchanges per day"
                   }
                 }
          }.not_to change(PD::Regime, :count)
          expect(PD::RegimeBag.count).to eq(1)
        end
      end

      describe "removing a bag" do
        it "removes a bag from the unsaved CAPD Regime" do
          create_capd_regime
          post :create,
               params: {
                 patient_id: patient,
                 actions: { remove: { "0" => "Remove" } },
                 pd_regime: {
                   type: "Renalware::PD::CAPDRegime",
                   start_date: Time.zone.today,
                   treatment: "CAPD 4 exchanges per day",
                   bags_attributes: [
                     {
                       bag_type_id: "100",
                       volume: "2",
                       per_week: "1",
                       monday: true
                     }
                   ]
                 }
               }

          expect(PD::RegimeBag.count).to eq(1)
        end
      end
    end

    describe "GET show" do
      it "responds with success" do
        capd_regime = create_capd_regime
        get :show, params: { id: capd_regime.id, patient_id: patient }
        expect(response).to be_successful
      end
    end

    describe "GET edit" do
      it "responds with success" do
        capd_regime = create_capd_regime
        get :edit, params: { id: capd_regime.id, patient_id: patient }
        expect(response).to be_successful
      end
    end

    describe "PUT #update" do
      context "with valid attributes" do
        it "updates a CAPD Regime" do
          capd_regime = create_capd_regime
          put :update,
              params: {
                id: capd_regime.id,
                patient_id: patient,
                pd_regime: {
                  type: "Renalware::PD:CAPDRegime",
                  start_date: "15/02/2015",
                  treatment: "CAPD 5 exchanges per day"
                }
              }

          expect(response).to redirect_to(patient_pd_dashboard_path(patient))
        end
      end

      context "with invalid attributes" do
        it "update a CAPD Regime" do
          capd_regime = create_capd_regime
          put :update,
              params: {
                id: capd_regime.id,
                patient_id: patient,
                pd_regime: {
                  type: "Renalware::PD::CAPDRegime",
                  start_date: nil,
                  treatment: nil
                }
              }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
