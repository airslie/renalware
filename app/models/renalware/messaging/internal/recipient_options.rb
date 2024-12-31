# Builds grouped drop down options for potential private message recipients.
# The groups are:
# - users who have recently received a message about the current patient
# - users who have recently received a message from the current author (excluding those already
#   listed in the above group)
# - all remaining users
#
# The author is excluded from all lists so they cannot send to themselves
#

module Renalware
  module Messaging
    module Internal
      class RecipientOptions
        attr_reader :patient, :author

        class Group
          include Virtus.model
          attribute :name, String
          attribute :users, Array, default: []
        end

        def initialize(patient, author)
          @patient = patient
          @author = author
        end

        def to_a
          [
            users_having_previously_received_a_message_about_patient,
            users_having_recently_received_messages_from_author,
            all_other_users
          ]
        end

        private

        def users_having_previously_received_a_message_about_patient
          Group.new(
            name: "Previous patient recipients",
            users: Recipient.where(id: ids_of_users_having_received_a_message_about_patient)
          )
        end

        def users_having_recently_received_messages_from_author
          Group.new(
            name: "Other recent recipients",
            users: Recipient.where(id: ids_of_users_having_received_messages_from_author)
          )
        end

        def all_other_users
          ids_to_exclude = ids_of_users_having_received_a_message_about_patient +
                           ids_of_users_having_received_messages_from_author +
                           ids_of_excludable_users

          Group.new(
            name: "All other users",
            users: Recipient.where.not(id: ids_to_exclude)
          )
        end

        def ids_of_users_having_received_a_message_about_patient
          @ids_of_users_having_received_a_message_about_patient ||= begin
            ids = Message
              .includes(:receipts)
              .eager_load(:receipts)
              .where(patient: patient)
              .limit(20)
              .pluck(:author_id, :recipient_id)
              .flatten.uniq.compact
            ids - ids_of_excludable_users
          end
        end

        def ids_of_users_having_received_messages_from_author
          @ids_of_users_having_received_messages_from_author ||= begin
            ids = Message
              .includes(:receipts)
              .eager_load(:receipts)
              .where(author: author)
              .limit(20)
              .pluck(:recipient_id).uniq.compact
            ids -
              ids_of_users_having_received_a_message_about_patient -
              ids_of_excludable_users
          end
        end

        def ids_of_excludable_users
          User.excludable.pluck(:id)
        end
      end
    end
  end
end
