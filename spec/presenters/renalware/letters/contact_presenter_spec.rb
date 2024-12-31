module Renalware
  module Letters
    describe ContactPresenter do
      subject(:presenter) { described_class.new(contact) }

      let(:contact) { build(:letter_contact) }

      describe "#description_name" do
        context "with a specified description" do
          let(:specified_contact_description) { build(:letter_contact_description) }

          before do
            contact.description = specified_contact_description
          end

          it "presents the original description name" do
            expect(presenter.description_name).to eq(specified_contact_description.name)
          end
        end

        context "with an unspecified description" do
          let(:unspecified_contact_description) { build(:letter_contact_description, :unspecified) }

          before do
            contact.description = unspecified_contact_description
            contact.other_description = "Great Uncle"
          end

          it "presents the contact's other description" do
            expect(presenter.description_name).to eq(contact.other_description)
          end
        end
      end

      describe "#salutation" do
        before { Renalware.config.salutation_prefix = "Dear" }

        context "when there is a title" do
          it "formats as Mr Smith" do
            person = Directory::Person.new(title: "Mr", given_name: "John", family_name: "Smith")
            contact = Contact.new(person: person)

            expect(described_class.new(contact).salutation).to eq("Dear Mr Smith")
          end
        end

        context "when there is no title" do
          it "formats as John Smith" do
            person = Directory::Person.new(title: "", given_name: "John", family_name: "Smith")
            contact = Contact.new(person: person)

            expect(described_class.new(contact).salutation).to eq("Dear John Smith")
          end
        end
      end
    end
  end
end
