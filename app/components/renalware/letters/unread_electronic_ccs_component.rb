module Renalware
  module Letters
    class UnreadElectronicCCsComponent < ApplicationComponent
      include Pundit::Helper

      pattr_initialize [:current_user!]

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt
            .includes(letter: [:patient, :author, :letterhead])
            .unread
            .for_recipient(current_user.id)
            .order(created_at: :asc)
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end
    end
  end
end
