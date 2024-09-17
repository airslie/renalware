# frozen_string_literal: true

module Renalware
  module Letters
    describe Contact do
      it { is_expected.to belong_to(:patient).touch(true) }

      describe "validation" do
        it :aggregate_failures do
          is_expected.to validate_presence_of(:person)
          is_expected.to validate_presence_of(:description)
        end

        context "when a contact has a specific description" do
          subject { described_class.new(description: specific_contact_description) }

          let(:specific_contact_description) do
            build(:letter_contact_description, system_code: "sibling")
          end

          it { is_expected.not_to validate_presence_of(:other_description) }
        end

        context "when a contact has a non-specific description" do
          subject { described_class.new(description: non_specific_contact_description) }

          let(:non_specific_contact_description) do
            build(:letter_contact_description, system_code: "other")
          end

          it { is_expected.to validate_presence_of(:other_description) }
        end

        context "when the person is already a contact for the patient" do
          let(:patient) { create(:letter_patient) }
          let(:person) { create(:directory_person, by: create(:user)) }

          before do
            contact = build_contact(person, patient)
            contact.save!
          end

          it "requires unique person for the patient" do
            new_contact = build_contact(person, patient)
            new_contact.valid?
            expect(new_contact.errors[:person]).to match(["is already a contact for the patient"])
          end
        end
      end

      def build_contact(person, patient)
        build(:letter_contact, person: person, patient: patient)
      end
    end
  end
end
