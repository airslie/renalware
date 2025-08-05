# Builds grouped drop down options for potential private message recipients.
# The groups are:
# - users who have recently received a message about the current patient
# - users who have recently received a message from the current author (excluding those already
#   listed in the above group)
# - all remaining users
#
# We work with arrays of user ids so we can easily order build the distinct lists.
# There might be a more efficient or clearer way to do.
module Renalware
  module Messaging
    module Internal
      class RecipientOptions
        pattr_initialize :patient, :author

        class Group
          include Virtus.model

          attribute :name, String
          attribute :users, Array, default: []
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
            users: ordered_recipients(ids_of_users_having_received_a_message_about_patient)
          )
        end

        def users_having_recently_received_messages_from_author
          Group.new(
            name: "Other recent recipients",
            users: ordered_recipients(ids_of_users_having_received_messages_from_author)
          )
        end

        def all_other_users
          ids_to_exclude = ids_of_users_having_received_a_message_about_patient +
                           ids_of_users_having_received_messages_from_author +
                           ids_of_excludable_users

          Group.new(
            name: "All other users",
            users: Recipient.where.not(id: ids_to_exclude).order(:family_name, :given_name)
          )
        end

        def ids_of_users_having_received_a_message_about_patient
          @ids_of_users_having_received_a_message_about_patient ||= begin
            ids = Message
              .includes(:receipts)
              .eager_load(:receipts)
              .where(patient: patient)
              .order(created_at: :desc)
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
              .order(created_at: :desc)
              .limit(20)
              .pluck(:recipient_id).uniq.compact
            ids -
              ids_of_users_having_received_a_message_about_patient -
              ids_of_excludable_users
          end
        end

        def ids_of_excludable_users
          User.excludable.order(:family_name, :given_name).pluck(:id)
        end

        def sanitize(*) = Arel.sql(ActiveRecord::Base.sanitize_sql_array(*))

        # In order to preserve the order of the user_ids we need to use a join with
        # unnest(ARRAY[?]) WITH ORDINALITY t(id, ord) USING (id)
        # and order by t.ord. However this code does not work with an empty array []
        # so we handle that differently.
        def ordered_recipients(arr_of_user_ids)
          return Recipient.none if arr_of_user_ids.empty?

          Recipient.joins(
            sanitize(
              [
                "join unnest(ARRAY[?]) WITH ORDINALITY t(id, ord) USING (id)",
                arr_of_user_ids
              ]
            )
          ).order("t.ord")
        end
      end
    end
  end
end
