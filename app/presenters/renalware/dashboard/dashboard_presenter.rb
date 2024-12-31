module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @user = user
      end

      attr_reader :user

      def bookmarks
        @bookmarks ||= begin
          Patients
            .cast_user(user)
            .bookmarks
            .ordered
            .includes(patient: [current_modality: :description])
        end
      end

      # Note we want oldest letters ordered first on the dashboard - elsewhere letters
      # are newest first
      def letters_in_progress
        @letters_in_progress ||= begin
          present_letters(
            Letters::Letter
              .reversed
              .where("author_id = ? or created_by_id = ?", user.id, user.id)
              .in_progress
              .includes(:author, :patient, :letterhead)
          )
          # Renalware::Letters.cast_author(user)
        end
      end

      def unread_messages_receipts
        @unread_messages_receipts ||= begin
          receipts = Messaging::Internal.cast_recipient(user)
            .receipts
            .includes(message: [:author, :patient])
            .order("messaging_messages.sent_at asc")
            .unread
          CollectionPresenter.new(receipts, Messaging::Internal::ReceiptPresenter)
        end
      end

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt
            .includes(letter: [:patient, :author, :letterhead])
            .unread
            .for_recipient(user.id)
            .order(created_at: :asc)
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
