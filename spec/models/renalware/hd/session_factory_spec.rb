# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe SessionFactory, type: :model do
      let(:user) { create(:user, :admin) }
      let(:patient) { create(:hd_patient) }

      describe "building a new ongoing session" do
        subject(:factory) { SessionFactory.new(patient: patient, user: user) }

        describe "#build" do
          it "applies defaults to the session" do
            travel_to Time.zone.parse("2004-11-24 01:04:44")

            session = factory.build

            expect(session).to be_a Session::Open
            expect(session.performed_on.to_s).to eq("2004-11-24")
            expect(session.start_time.to_s(:time)).to eq("01:00")
            expect(session.signed_on_by).to eq(user)
          end

          context "with HD profile" do
            let!(:profile) { create(:hd_profile, patient: patient) }

            it "applies defaults from HD profile" do
              session = factory.build

              expect(session.hospital_unit).to eq(profile.hospital_unit)
              expect(session.document.info.hd_type).to eq(profile.document.dialysis.hd_type)
            end
          end

          context "with a current access" do
            let(:accesses_patient) { Accesses.cast_patient(patient) }
            let!(:profile) { create(:access_profile, :current, patient: accesses_patient) }

            it "applies the access details from the current access" do
              session = factory.build

              expect(session.document.info.access_type).to eq(profile.type.name)
              expect(session.document.info.access_side).to eq(profile.side)
            end
          end
        end
      end

      describe "building a dna session" do
        subject(:factory) { SessionFactory.new(patient: patient, user: user, type: "dna") }

        describe "#build" do
          it "applies defaults to the session" do
            travel_to Time.zone.parse("2004-11-24 01:04:44")

            session = factory.build

            expect(session).to be_a Session::DNA
            expect(session.performed_on.to_s).to eq("2004-11-24")
            expect(session.start_time.to_s(:time)).to eq("01:00")
            expect(session.signed_on_by).to eq(user)
          end

          context "with HD profile" do
            let!(:profile) { create(:hd_profile, patient: patient) }

            it "applies defaults from HD profile" do
              session = factory.build

              expect(session.hospital_unit).to eq(profile.hospital_unit)
            end
          end
        end
      end
    end
  end
end
