module Renalware
  module Letters
    class ElectronicRecipientOptions
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
          users_having_previously_received_been_cced_about_this_patient,
          users_having_recently_been_cced_by_author,
          all_other_users
        ]
      end

      private

      def users_having_previously_received_been_cced_about_this_patient
        Group.new(
          name: "Previous CC recipients",
          users: User.where(
            id: ids_of_users_having_previously_received_been_cced_about_this_patient
          )
        )
      end

      def users_having_recently_been_cced_by_author
        Group.new(
          name: "Other recent recipients",
          users: User.where(id: ids_of_users_having_recently_been_cced_by_author)
        )
      end

      def all_other_users
        ids_to_exclude = ids_of_users_having_previously_received_been_cced_about_this_patient +
                         ids_of_users_having_recently_been_cced_by_author +
                         ids_of_excludable_users
        Group.new(
          name: "All other user",
          users: User.where.not(id: ids_to_exclude)
        )
      end

      def ids_of_users_having_previously_received_been_cced_about_this_patient
        @ids_of_users_having_previously_received_been_cced_about_this_patient ||= begin
          ids = Letter
            .includes(:electronic_receipts)
            .eager_load(:electronic_receipts)
            .where(patient: patient)
            .limit(20)
            .pluck(:recipient_id)
            .flatten.uniq.compact
          ids - ids_of_excludable_users
        end
      end

      def ids_of_users_having_recently_been_cced_by_author
        @ids_of_users_having_recently_been_cced_by_author ||= begin
          ids = Letter
            .includes(:electronic_receipts).eager_load(:electronic_receipts)
            .where(author: author)
            .limit(20)
            .pluck(:recipient_id).uniq.compact
          ids -
            ids_of_users_having_previously_received_been_cced_about_this_patient -
            ids_of_excludable_users
        end
      end

      def ids_of_excludable_users
        User.excludable.pluck(:id)
      end
    end
  end
end
