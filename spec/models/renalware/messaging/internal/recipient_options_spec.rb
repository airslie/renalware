module Renalware::Messaging::Internal
  describe RecipientOptions do
    let(:author) { create(:internal_author) }
    let(:another_user) { create(:internal_recipient) }
    let(:patient_a) { create(:messaging_patient) }
    let(:patient_b) { create(:messaging_patient) }
    let(:recipient_for_message_re_patient_a) { create(:internal_recipient) }
    let(:recipient_for_message_re_patient_b) { create(:internal_recipient) }
    let(:form) do
      MessageForm.new(
        body: "Content",
        subject: "Subject",
        recipient_ids: [recipient_for_message_re_patient_a.id],
        urgent: false
      )
    end

    def send_message_about(patient:, to:)
      form = MessageForm.new(
        body: "Content..",
        subject: "Subject..",
        recipient_ids: [to.id],
        urgent: false
      )
      SendMessage.call(patient: patient, author: author, form: form)
    end

    def unapprove_user(user)
      vanilla_user(user).update!(approved: false)
    end

    def expire_user(user)
      vanilla_user(user).update_column(:expired_at, 1.day.ago)
    end

    def make_user_inactive(user)
      vanilla_user(user).update_column(:last_activity_at, 10.years.ago)
    end

    def hide_user(user)
      vanilla_user(user).update_column(:hidden, true)
    end

    def vanilla_user(user) = user.becomes(Renalware::User)

    describe "#to_h" do
      before do
        send_message_about(patient: patient_a, to: recipient_for_message_re_patient_a)
        send_message_about(patient: patient_b, to: recipient_for_message_re_patient_b)
        another_user # create this user
      end

      # rubocop:disable RSpec/MultipleExpectations
      it "returns a hash of 3 recipient groups" do
        # Lets get grouped dropdown options as if we again want to send a message about patient_a
        recipient_options = described_class.new(patient_a, author)

        groups = recipient_options.to_a

        expect(groups).to be_a(Array)
        expect(groups.length).to eq(3)

        # The first 2 groups should reflect recent message activity.
        #
        # The first group of users should users recently messaged about this patient:
        # - recipient_for_message_re_patient_a was recently messagesd about the patient_a so will be
        #   present in the list.
        # - recipient_for_message_re_patient_b has not been previously been messaged about patient_a
        #   so they will not be in the list
        # - We always include the self/author in this list so they can send to themselves easily.
        recent_patient_recipients = groups[0]
        expect(recent_patient_recipients.users.count).to eq(2)
        users = recent_patient_recipients.users
        expect(users).to include(recipient_for_message_re_patient_a)
        expect(users).not_to include(recipient_for_message_re_patient_b)
        expect(users).to include(Renalware::Messaging::Internal.cast_recipient(author))

        # The second group contains recipients recently messaged by the the current author,
        # where not not in the first group already. recipient_for_message_re_patient_b was recently
        # messaged (about a different patient) so will be in this group.
        recent_recipients_sent_by_author = groups[1].users
        expect(recent_recipients_sent_by_author).to eq([recipient_for_message_re_patient_b])

        # Everyone else will be in the 3rd group ie approved user not in the previous list
        # and not the author
        all_other_users = groups[2].users
        expect(all_other_users).not_to include(recipient_for_message_re_patient_a)
        expect(all_other_users).not_to include(recipient_for_message_re_patient_b)
        expect(all_other_users).not_to include(author)
        expect(all_other_users).to include(another_user)
      end
      # rubocop:enable RSpec/MultipleExpectations

      context "when a user as become unapproved, expired or inactive then they should " \
              "not appear in recipient options, even if they are a previous recipient for " \
              "messages about the current patient or from the current author" do
        it "returns a hash of 3 recipient groups with expired/unapproved/inactive users removed" do
          # Unapproved our users so they are excluded from returned results
          unapprove_user(recipient_for_message_re_patient_a)
          # expire_user(recipient_for_message_re_patient_b)
          hide_user(recipient_for_message_re_patient_b)
          make_user_inactive(another_user)

          # Get grouped dropdown options as if we want to send another message about patient_a
          recipient_options = described_class.new(patient_a, author)
          groups = recipient_options.to_a

          # The first group of users would normally contain recipient_for_message_re_patient_a as
          # they were recently messaged about this patient. However they have just been unapproved
          # so should not be in the list. recipient_for_message_re_patient_b has not been
          # messaged previously about patient_a so they will not be in the list (and they are
          # unapproved now anyway!)
          recent_patient_recipients = groups[0]
          expect(recent_patient_recipients).to be_a(RecipientOptions::Group)
          expect(recent_patient_recipients.users).not_to include(recipient_for_message_re_patient_a)
          expect(recent_patient_recipients.users).not_to include(recipient_for_message_re_patient_b)

          # The second group contains recipients recently messaged by the the current author,
          # where not not in the first group already.
          recent_recipients_sent_by_author = groups[1]
          expect(recent_recipients_sent_by_author.users.count).to eq(0)

          # Everyone else excluding anyone already listed and the current author
          all_other_users = groups[2]
          expect(all_other_users.users).not_to include(another_user)
        end
      end
    end
  end
end
