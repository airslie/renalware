module Renalware
  module Messaging
    module Internal
      describe SendMessageToUsersWithRole do
        subject(:service) { described_class }

        let(:patient)     { create(:patient) }
        let(:author)      { create(:user, :system) }
        let(:role_name)   { :super_admin }
        let(:msg_subject) { "The Subject" }
        let(:body)        { "The Body" }

        describe "#call" do
          it "sends the message to all users with that role" do
            super_admin1 = create(:user, :super_admin, family_name: "super_admin1")
            super_admin2 = create(:user, :super_admin, family_name: "super_admin2")
            create(:user, :clinical, family_name: "clinical1")
            msg = nil
            expect do
              msg = service.call(
                patient:,
                author:,
                role_name:,
                subject: msg_subject,
                body:
              )
            end.to change(Message, :count).by(1)
              .and change(Recipient, :count).by(2)

            expect(msg).to have_attributes(
              patient_id: patient.id,
              author_id: author.id,
              subject: msg_subject,
              body:
            )
            expect(msg.recipient_ids).to contain_exactly(super_admin1.id, super_admin2.id)
          end
        end
      end
    end
  end
end
