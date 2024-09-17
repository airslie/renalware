# frozen_string_literal: true

module Renalware
  module Letters
    describe RecipientPresenter::WithCurrentAddress do
      include LettersSpecHelper

      subject(:presenter) { described_class.new(recipient) }

      let(:practice_name) { "Practice1" }
      let(:address_organisation_name) { "AddressOrgName" }
      let(:practice) do
        build(:practice, name: practice_name).tap do |prac|
          prac.build_address(attributes_for(:address, organisation_name: address_organisation_name))
        end
      end
      let(:patient) { build(:letter_patient, practice: practice) }
      let(:recipient) { letter.main_recipient }

      describe "#address" do
        context "when the recipient's role is patient" do
          let(:letter) { build_letter(to: :patient, patient: patient) }

          it "returns the address of the patient" do
            expect(presenter.address).to eq(letter.patient.current_address)
          end
        end

        context "when the recipient's role is Primary Care Physician" do
          let(:letter) { build_letter(to: :primary_care_physician, patient: patient) }

          it "returns the address of the Practice" do
            expect(presenter.address).to eq(letter.patient.practice.address)
          end

          context "when there is no organisation name in the address" do
            let(:practice_name) { "Practice1" }
            let(:address_organisation_name) { nil }

            it "uses the pratice name" do
              expect(presenter.address.organisation_name).to eq("Practice1")
            end
          end

          context "when there is an organisation name in the address" do
            let(:practice_name) { "Practice1" }
            let(:address_organisation_name) { "AddressOrgName" }

            it "uses that and does not copy across the pratice name" do
              expect(presenter.address.organisation_name).to eq("AddressOrgName")
            end
          end
        end

        context "when the recipient's role is contact" do
          let(:letter) { build_letter(to: :contact, patient: patient) }

          it "returns the recipient's address" do
            expect(presenter.address).to eq(recipient.current_address)
          end
        end
      end
    end
  end
end
