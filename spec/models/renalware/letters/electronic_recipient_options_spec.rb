module Renalware
  module Letters
    describe ElectronicRecipientOptions do
      include LettersSpecHelper

      let(:patient) { create(:letter_patient, by: author) }
      let(:another_patient) { create(:letter_patient, by: author) }
      let(:author) { create(:user, given_name: "author") }
      let(:recipient1) { create(:user, given_name: "recipient1") }
      let(:disinterested_user) { create(:user) }

      def unapprove_user(user)
        vanilla_user(user).update!(approved: false)
      end

      def hide_user(user)
        vanilla_user(user).update_column(:hidden, true)
      end

      def expire_user(user)
        vanilla_user(user).update_column(:expired_at, 1.day.ago)
      end

      def make_user_inactive(user)
        vanilla_user(user).update_column(:last_activity_at, 10.years.ago)
      end

      def vanilla_user(user) = user.becomes(Renalware::User)

      before do
        disinterested_user # create this user
      end

      describe "#to_a" do
        context "when a user has been a previous e-cc on a letter for a particular patient" do
          before do
            letter = create_letter(to: :patient, patient: patient, by: author)
            letter.electronic_cc_recipients << recipient1
            letter.save_by!(author)
          end

          it "returns that user in the first group only" do
            options = described_class.new(patient, author)
            groups = options.to_a

            users = groups[0].users
            expect(users).to include(recipient1)
            expect(users).not_to include(author)

            users = groups[1].users
            expect(users).to be_empty

            users = groups[2].users
            expect(users).not_to include(recipient1)
            expect(users).to include(author)
            expect(users).to include(disinterested_user)
          end

          context "when the previous e-cc recipient subsequently becomes unapproved" do
            it "they do not appear in the first group" do
              unapprove_user(recipient1)

              options = described_class.new(patient, author)

              users = options.to_a[0].users
              expect(users).not_to include(recipient1)
            end
          end

          context "when the previous e-cc recipient subsequently becomes hidden" do
            it "they do not appear in the first group" do
              hide_user(recipient1)

              options = described_class.new(patient, author)

              users = options.to_a[0].users
              expect(users).not_to include(recipient1)
            end
          end
        end

        context "when a user has not been a previous e-cc but for this patient, but has been a " \
                "CC on a letter to another patient by the same author" do
          before do
            letter = create_letter(to: :patient, patient: another_patient, by: author)
            letter.electronic_cc_recipients << recipient1
            letter.save_by!(author)
          end

          it "returns that user in the second group only" do
            options = described_class.new(patient, author)
            groups = options.to_a

            users = groups[0].users
            expect(users).to be_empty

            users = groups[1].users
            expect(users).to include(recipient1)
            expect(users).not_to include(author)

            users = groups[2].users
            expect(users).not_to include(recipient1)
            expect(users).to include(author)
            expect(users).to include(disinterested_user)
          end

          context "when the user subsequently becomes unapproved" do
            it "they do not appear in the second group" do
              unapprove_user(recipient1)

              options = described_class.new(patient, author)
              groups = options.to_a

              expect(groups[0].users).to be_empty
              expect(groups[1].users).not_to include(recipient1)
              expect(groups[2].users).not_to include(recipient1)
            end
          end

          context "when the user subsequently becomes expired" do
            it "they do not appear in the second group" do
              expire_user(recipient1)

              options = described_class.new(patient, author)
              groups = options.to_a

              expect(groups[0].users).to be_empty
              expect(groups[1].users).not_to include(recipient1)
              expect(groups[2].users).not_to include(recipient1)
            end
          end

          context "when the user subsequently becomes hidden" do
            it "they do not appear in the second group" do
              hide_user(recipient1)

              options = described_class.new(patient, author)
              groups = options.to_a

              expect(groups[0].users).to be_empty
              expect(groups[1].users).not_to include(recipient1)
              expect(groups[2].users).not_to include(recipient1)
            end
          end

          context "when the user subsequently becomes inactive" do
            it "they do not appear in the second group" do
              make_user_inactive(recipient1)

              options = described_class.new(patient, author)
              groups = options.to_a

              expect(groups[0].users).to be_empty
              expect(groups[1].users).not_to include(recipient1)
              expect(groups[2].users).not_to include(recipient1)
            end
          end
        end

        context "when a disinterested user becomes unapproved" do
          it "they do not appear in any list" do
            unapprove_user(disinterested_user)

            options = described_class.new(patient, author)
            groups = options.to_a

            expect(groups[0].users).to be_empty
            expect(groups[1].users).to be_empty
            expect(groups[2].users).not_to include(disinterested_user)
          end
        end

        context "when a disinterested user becomes hidden" do
          it "they do not appear in any list" do
            hide_user(disinterested_user)

            options = described_class.new(patient, author)
            groups = options.to_a

            expect(groups[0].users).to be_empty
            expect(groups[1].users).to be_empty
            expect(groups[2].users).not_to include(disinterested_user)
          end
        end
      end
    end
  end
end
