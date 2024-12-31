# A Receipt is cross reference between Message and Recipient.
# We can for instance mark on a receipt if/when it was read or viewed.
module Renalware
  module Messaging
    module Internal
      class ReceiptsController < BaseController
        include Pagy::Backend
        include PresenterHelper

        # GET aka inbox
        def unread
          render_receipts(unread_receipts)
        end

        # GET all read messages
        def read
          render_receipts(read_receipts)
        end

        # GET all sent messages
        def sent
          render_receipts(sent_receipts)
        end

        # PATCH
        def mark_as_read
          authorize receipt
          receipt.update(read_at: Time.zone.now)
          render locals: {
            receipt: ReceiptPresenter.new(receipt)
          }
        end

        private

        def render_receipts(receipts)
          receipts = receipts.joins(message: [:patient])
          if search_term.present?
            receipts = patient_filter.call(receipts)
          end
          pagy, receipts = pagy(receipts)
          authorize receipts

          render locals: {
            receipts: present(receipts, ReceiptPresenter),
            search_form: patient_filter.search_form,
            pagy: pagy
          }
        end

        def receipts
          @receipts ||= recipient.receipts
        end

        def receipt
          @receipt ||= recipient.receipts.find_by!(
            message_id: params[:message_id],
            id: params[:id]
          )
        end

        def recipient
          Messaging::Internal.cast_recipient(current_user)
        end

        def search_term
          params.fetch(:patient_search, {}).fetch(:term, nil)
        end

        def unread_receipts
          receipts.unread.order("messaging_messages.sent_at asc")
        end

        def sent_receipts
          Receipt.sent_by(current_user.id).ordered
        end

        def read_receipts
          receipts.read.ordered
        end

        def patient_filter
          @patient_filter ||= Patients::SearchFilter.new(search_term, request)
        end
      end
    end
  end
end
