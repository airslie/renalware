require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Contact, type: :model do
      describe "validation" do
        it { is_expected.to validate_presence_of(:person) }
        it { is_expected.to validate_presence_of(:description) }

        context "given a contact with a specific description" do
          let(:specific_contact_description) do
            build(:letter_contact_description, system_code: "sibling")
          end
          subject { Contact.new(description: specific_contact_description) }

          it { is_expected.not_to validate_presence_of(:other_description) }
        end

        context "given a contact with a non-specific description" do
          let(:non_specific_contact_description) do
            build(:letter_contact_description, system_code: "other")
          end
          subject { Contact.new(description: non_specific_contact_description) }

          it { is_expected.to validate_presence_of(:other_description) }
        end

        context "given the person is already a contact for the patient" do
          let(:patient) { create(:letter_patient) }
          let(:person) { create(:directory_person, by: create(:user)) }

          before do
            contact = build_contact(person, patient)
            contact.save!
          end

          it "requires unique person for the patient" do
            new_contact = build_contact(person, patient)
            new_contact.valid?
            expect(new_contact.errors[:person]).to match([/is already a contact for the patient/])
          end
        end
      end

      def build_contact(person, patient)
        build(:letter_contact, person: person, patient: patient)
      end
    end
  end
end
